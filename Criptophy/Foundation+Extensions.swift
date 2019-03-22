//
//  Foundation+Extensions.swift
//  CipherTest
//
//  Created by Omar Eduardo Gomez Padilla on 1/15/19.
//  Copyright © 2019 Omar Eduardo Gomez Padilla. All rights reserved.
//

import Foundation
import os.log

public extension Data {

    static func randomData(size: Int) -> Data? {
        var data = Data(count: size)
        let result = data.withUnsafeMutableBytes {
            (mutableBytes: UnsafeMutablePointer<UInt8>) -> Int32 in
            SecRandomCopyBytes(kSecRandomDefault, size, mutableBytes)
        }
        
        if result != errSecSuccess {
            return nil
        }
        
        return data
    }
    
    public static func archive<T: Any>(_ value: T) -> Data? {
        let result = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
        return result
    }
    
    public func unarchive<T>(toType: T.Type) -> T?
    {
        guard let raw = ((try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(self)) ?? nil) else {
            return nil
        }
        
        guard let result = raw as? T else {
            return nil
        }
        
        return result
    }
    
    public static func fromBytes<T>(_ value: T) -> Data {
        return Swift.withUnsafeBytes(of: value) { Data($0) }
    }
    
    public func toBytes<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.pointee }
    }
}

extension OSLog {
    static let logger = OSLog(subsystem: "github.Criptophy", category: "Criptophy")
}
