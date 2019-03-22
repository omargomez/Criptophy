//
//  CriptophyTests.swift
//  CriptophyTests
//
//  Created by Omar Eduardo Gomez Padilla on 3/22/19.
//  Copyright © 2019 Omar Eduardo Gomez Padilla. All rights reserved.
//

import XCTest
@testable import Criptophy

class CriptophyTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCipher() {
        let inString = "Hallo welt"
        let inData = inString.data(using: .utf8)!
        let encrypted = Cipher.shared.encrypt(inData)!
        let decrypted = Cipher.shared.decrypt(encrypted)!
        let outString = String(data: decrypted, encoding: .utf8)

        XCTAssertEqual(outString, inString, "decripted string differs!!!")
    }

    func testDecorator() {
        
        let decorator = UserDefaultsDecorator(UserDefaults.standard)
        
        let inArr = ["a", "b", "c"]
        decorator.set(inArr, forKey: "anArray")
        let outArr = decorator.object(forKey: "anArray") as? [String]
        XCTAssertEqual(outArr!, inArr, "String Array differs!!!")

        let inFloat: Float = 3.1416
        decorator.set(inFloat, forKey: "pi")
        let outFloat = decorator.float(forKey: "pi")
        XCTAssertEqual(outFloat, inFloat, "Float differs!!!")
        
        let inDouble: Double = 1.618
        decorator.set(inDouble, forKey: "phi")
        let outDouble = decorator.double(forKey: "phi")
        XCTAssertEqual(outDouble, inDouble, "Doubles differs!!!")

        let inURL = URL(string: "https://google.com")
        decorator.set(inURL, forKey: "google")
        let outURL = decorator.url(forKey: "google")!
        XCTAssertEqual(outURL, inURL, "URLs differs!!!")

        let inDict: [String:Float] = ["pi": 3.1416, "phi": 0.618]
        decorator.set(inDict, forKey: "dict")
        let outDict = decorator.dictionary(forKey: "dict")! as! [String:Float]
        XCTAssertEqual(inDict, outDict, "Dicts differs!!!")

        let inData = "Hallo".data(using: .utf8)
        decorator.set(inData, forKey: "someData")
        let outData = decorator.data(forKey: "someData")!
        XCTAssertEqual(outData, inData, "Data differs!!!")

    }

}
