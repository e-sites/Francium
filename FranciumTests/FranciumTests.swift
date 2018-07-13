//
//  FranciumTests.swift
//  FranciumTests
//
//  Created by Bas van Kuijck on 13/07/2018.
//  Copyright © 2018 E-sites. All rights reserved.
//

import XCTest
@testable import Francium

class FranciumTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    private func _createTestDirectory() {

    }

    func testFile() {
        let file = File(path: "somenewfile.txt")
        XCTAssertEqual(file.isExisting, false)
        XCTAssertEqual(file.basename, "somenewfile.txt")
        XCTAssertEqual(file.name, "somenewfile")
        XCTAssertEqual(file.extensionName, "txt")
        XCTAssertNil(file.creationDate)
        XCTAssertNil(file.modificationDate)
    }

    func testDir() {
        let dir = Dir(path: "./")
        XCTAssertEqual(dir.isExisting, true)
        XCTAssertEqual(dir.isDirectory, true)
        XCTAssertNotNil(dir.creationDate)
        XCTAssertNotNil(dir.modificationDate)
    }

    func testCreation() {
        do {
            let dir = try Dir.create(path: "./SomeNewDirectory")
            XCTAssertNotNil(dir.creationDate)
            XCTAssertEqual(dir.permissions, 0o0777)
            XCTAssertEqual(dir.basename, "SomeNewDirectory")

            let file = try File.create(path: "./SomeNewDirectory/somenewfile.txt")
            XCTAssertEqual(file.permissions, 0o0777)
            XCTAssertNotNil(file.creationDate)
            XCTAssertEqual(file.basename, "somenewfile.txt")
            try file.write(string: "Some information")
            XCTAssertEqual(file.contents, "Some information")

            XCTAssertEqual(dir.glob("*").count, 1)
            XCTAssertEqual(dir.glob("some*").count, 1)
            XCTAssertEqual(dir.glob("*.txt").count, 1)
            XCTAssertEqual(dir.glob("*.md").count, 0)
            try file.delete()
            try dir.delete()
        } catch let error {
            XCTAssert(false, "\(error)")
        }
    }

    func testEmpty() {
        do {
            let dir = try Dir.create(path: "./SomeNewDirectory")
            let file = try File.create(path: "./SomeNewDirectory/somenewfile.txt")
            try dir.empty()
            XCTAssertEqual(dir.glob("*").count, 0)
            XCTAssertEqual(file.isExisting, false)
            try dir.delete()

        } catch let error {
            XCTAssert(false, "\(error)")
        }
    }

    func testAppend() {
        do {
            let file = try File.create(path: "./somenewfile.txt")
            try file.write(string: "Some information")
            XCTAssertEqual(file.contents, "Some information")
            try file.append(string: ">>>")
            XCTAssertEqual(file.contents, "Some information>>>")

            try file.delete()

        } catch let error {
            XCTAssert(false, "\(error)")
        }
    }
}
