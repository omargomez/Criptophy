//
//  Foundation+Extensions.swift
//  CipherTest
//
//  Created by Omar Eduardo Gomez Padilla on 1/15/19.
//  Copyright © 2019 Omar Eduardo Gomez Padilla. All rights reserved.
//

import Foundation
import os.log

extension Data {

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
    
}

extension OSLog {
    static let logger = OSLog(subsystem: "github.Criptophy", category: "Criptophy")
}
