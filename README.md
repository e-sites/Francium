![Francium](Assets/logo.png)

Francium is part of the **[E-sites iOS Suite](https://github.com/e-sites/iOS-Suite)**.

---

A small library to use for your file system.

[![forthebadge](http://forthebadge.com/images/badges/made-with-swift.svg)](http://forthebadge.com) [![forthebadge](http://forthebadge.com/images/badges/built-with-swag.svg)](http://forthebadge.com)

[![Platform](https://img.shields.io/cocoapods/p/Francium.svg?style=flat)](http://cocoadocs.org/docsets/Francium)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Francium.svg)](http://cocoadocs.org/docsets/Francium)
[![Quality](https://apps.e-sites.nl/cocoapodsquality/Francium/badge.svg?004)](https://cocoapods.org/pods/Francium/quality)
[![Travis-ci](https://travis-ci.org/e-sites/Francium.svg?branch=master&001)](https://travis-ci.org/e-sites/Francium)


# Installation

Podfile:

```ruby
pod 'Francium'
```

And then

```
pod install
```

# Implementation

Both `File` and `Dir` implement the following functions / properties:

```swift

 /// The absolute path:
/// `File("path: ./").absolutePath #=> /var/folders/6d/FranciumTests-61688042-63CA-4E70-A9A6-31BBBB12FD38/`
public var absolutePath: String 

/// Does the entry exist?
public var isExisting: Bool

/// The base name
/// `File("path: /usr/bin/testfile.swift") #=> testfile.swift`
public var basename: String 

/// The file (or directory) name without the final extension
/// `File("path: testfile.rb").name #=> testfile`
public var name: String

public var isDirectory: Bool 

/// The name of the directory
/// `File("path: testfile.rb").dirname #=> /var/folders/6d`
/// `Dir("path: ./").dirname #=> /var/folders/6d`
public var dirName: String

public var modificationDate: Date?
public var creationDate: Date?

// ---- Path

public func delete() throws
public func rename(to newName: String) throws
public func move(to dir: Dir, newName: String? = nil) throws 
public func copy(to dir: Dir, newName: String? = nil) throws

// ---- Permissions

public func chmod(_ value: Int)

public var permissions: Int?
```

## `File`

```swift
/// The extension name
/// `File("path: testfile.rb").extensionName #=> rb`
public var extensionName: String

public static func create(path: String, permissions: Int = 0o0777) throws -> File
public func create() throws

public func write(data: Data) throws
public func write(string: String) throws
public func append(string: String) throws
public func append(data: Data) throws

public func read() throws -> Data
public var contents: String?

```

## `Dir`

```swift
public static func create(path: String,
                          withIntermediateDirectories: Bool = true,
                          permissions: Int = 0o0777) throws -> Dir

public func make(withIntermediateDirectories: Bool = true) throws

public func glob(_ pattern: String) -> [File]
public func empty(recursively: Bool = true) throws
```