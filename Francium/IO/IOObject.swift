//
//  Pointer.swift
//  Francium
//
//  Created by Bas van Kuijck on 13/07/2018.
//  Copyright © 2018 E-sites. All rights reserved.
//

import Foundation

public class IOObject {

    public let path: String
    let url: URL

    public init(path: String) {
        self.path = path
        self.url = URL(fileURLWithPath: path)
    }

    public var absolutePath: String {
        return url.path
    }

    public var isExisting: Bool {
        return FileManager.default.fileExists(atPath: absolutePath)
    }

    public var basename: String {
        return url.lastPathComponent
    }

    public var name: String {
        var expl = url.lastPathComponent.components(separatedBy: ".")
        expl.removeLast()
        return expl.joined(separator: ".")
    }

    public var isDirectory: Bool {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDir) {
            return isDir.boolValue
        } else {
            return false
        }
    }

    public var dirName: String {
        var components = url.pathComponents
        if !isDirectory {
            components.removeLast()
        }

        if components.last == "" {
            components.removeLast()
        }
        return components.joined(separator: "/")
    }


    public var modificationDate: Date? {
        return _attribute(type: Date.self, for: .modificationDate)
    }

    public var creationDate: Date? {
        return _attribute(type: Date.self, for: .creationDate)
    }
}

extension IOObject {
    public func delete() throws {
        try FileManager.default.removeItem(atPath: absolutePath)
    }
}

extension IOObject {
    public func rename(to newName: String) throws {
        try move(to: Dir(path: dirName), newName: newName)
    }

    public func move(to dir: Dir, newName: String? = nil) throws {
        try FileManager.default.moveItem(atPath: absolutePath, toPath: dir.dirName + "/" + (newName ?? basename))
    }

    public func copy(to dir: Dir, newName: String? = nil) throws {
        try FileManager.default.copyItem(atPath: absolutePath, toPath: dir.dirName + "/" + (newName ?? basename))
    }
}

extension IOObject {
    public func chmod(_ value: Int) {
        _setAttribute(value: value, for: .posixPermissions)
    }

    public var permissions: Int? {
        return _attribute(type: Int.self, for: .posixPermissions)
    }
}

extension IOObject {
    fileprivate func _attribute<T>(type: T.Type, `for` key: FileAttributeKey) -> T? {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: absolutePath)
            return attributes[key] as? T

        } catch {
            return nil
        }
    }

    fileprivate func _setAttribute(value: Any, for key: FileAttributeKey) {
        do {
            var attributes = try FileManager.default.attributesOfItem(atPath: absolutePath)
            attributes[key] = value
            try FileManager.default.setAttributes(attributes, ofItemAtPath: absolutePath)
        } catch {
        }
    }
}

