//
//  File.swift
//  Francium
//
//  Created by Bas van Kuijck on 13/07/2018.
//  Copyright © 2018 E-sites. All rights reserved.
//

import Foundation

public class File: IOObject, CustomStringConvertible {
    /// The extension name
    /// `File("path: testfile.rb").extensionName #=> rb`
    public var extensionName: String {
        let expl = url.lastPathComponent.components(separatedBy: ".")
        return expl.last ?? ""
    }

    public static func create(path: String, permissions: Int = 0o0777) throws -> File {
        let file = File(path: path)
        try file.create()
        file.chmod(permissions)
        return file
    }

    public func create() throws {
        if isExisting {
            throw Error.alreadyExists
        }

        let attributes: [FileAttributeKey: Any] = [
            .posixPermissions: 0o777
        ]

        if !FileManager.default.createFile(atPath: absolutePath, contents: nil, attributes: attributes) {
            throw Error.cannotCreateFile
        }
    }

    public var description: String {
        return "<File> [ absolutePath: \(absolutePath) ]"
    }
}

extension File {
    public func write(data: Data) throws {
        try data.write(to: url)
    }

    public func write(string: String) throws {
        let data = string.data(using: .utf8) ?? Data()
        try write(data: data)
    }

    public func append(string: String) throws {
        let data = string.data(using: .utf8) ?? Data()
        try append(data: data)
    }

    public func append(data: Data) throws {
        if !isExisting {
            try write(data: data)
            return
        }

        guard let fileHandle = FileHandle(forUpdatingAtPath: path) else {
            try write(data: data)
            return
        }

        defer {
            fileHandle.closeFile()
        }
        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
    }

    public func read() throws -> Data {
        return try Data(contentsOf: url)
    }

    public var contents: String? {
        do {
            let data = try read()
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
