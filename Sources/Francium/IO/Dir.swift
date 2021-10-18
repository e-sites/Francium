//
//  Dir.swift
//  Francium
//
//  Created by Bas van Kuijck on 13/07/2018.
//  Copyright © 2018 E-sites. All rights reserved.
//

#if os(Linux)
import Glibc

let system_glob = Glibc.glob
#else
import Darwin

let system_glob = Darwin.glob
#endif

import Foundation

public class Dir: IOObject, CustomStringConvertible {
    
    override public var isExisting: Bool {
        return isDirectory && super.isExisting
    }

    public static func create(path: String,
                              withIntermediateDirectories: Bool = true,
                              permissions: Int = 0o0777) throws -> Dir {
        let dir = Dir(path: path)
        try dir.make(withIntermediateDirectories: withIntermediateDirectories)
        dir.chmod(permissions)
        return dir
    }

    public func make(withIntermediateDirectories: Bool = true) throws {
        if isDirectory {
            throw Error.alreadyExists
        }

        let attributes: [FileAttributeKey: Any] = [
            .posixPermissions: 0o777
        ]
        try FileManager.default.createDirectory(atPath: absolutePath,
                                                withIntermediateDirectories: withIntermediateDirectories,
                                                attributes: attributes)
    }

    public var description: String {
        return "<Dir> [ absolutePath: \(absolutePath) ]"
    }

    public func glob(_ pattern: String) -> [File] {
        let pattern = absolutePath + "/" + pattern
        guard let cPattern = strdup(pattern) else {
            return []
        }
        var gt = glob_t()
        defer {
            globfree(&gt)
            free(cPattern)
        }

        let flags = GLOB_TILDE | GLOB_BRACE | GLOB_MARK
        if system_glob(cPattern, flags, nil, &gt) == 0 {
            #if os(Linux)
            let matchc = gt.gl_pathc
            #else
            let matchc = gt.gl_matchc
            #endif

            return (0..<Int(matchc)).compactMap { index in
                if let path = String(validatingUTF8: gt.gl_pathv[index]!) {
                    return File(path: path)
                }

                return nil
            }
        }
        return []
    }

    public func empty(recursively: Bool = true) throws {
        let fileManager = FileManager.default
        let files = try fileManager.contentsOfDirectory(atPath: absolutePath)
            .map { File(path: "\(absolutePath)/\($0)") }
        for file in files {
            if file.isDirectory {
                let dir = Dir(path: file.path)
                if recursively {
                    try dir.empty(recursively: true)
                } else {
                    if !dir.glob("*").isEmpty {
                        throw Error.directoryNotEmpty
                    }
                }
            }
            try file.delete()
        }
    }
}
