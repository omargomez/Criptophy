//
//  Keychain.swift
//
//  Created by Omar Eduardo Gomez Padilla on 1/15/19.
//  Copyright © 2019 Omar Eduardo Gomez Padilla. All rights reserved.
//
//  Keychain wrapper utility
//

import Foundation
import os.log

class Keychain {
    
    private init() {}
    
    private static var _shared: Keychain?
    public static var shared: Keychain {
        get {
            if _shared == nil {
                DispatchQueue.global().sync(flags: .barrier) {
                    if _shared == nil {
                        _shared = Keychain()
                    }
                }
            }
            return _shared!
        }
    }
    
    open subscript(key: String) -> Data? {
        get {
            return load(withKey: key)
        } set {
            DispatchQueue.global().sync(flags: .barrier) {
                self.save(newValue, forKey: key)
            }
        }
    }
    
    private func save(_ theData: Data?, forKey key: String) {
        let query = keychainQuery(withKey: key)        
        let objectData: Data? = theData

        if SecItemCopyMatching(query, nil) == noErr {
            if let dictData = objectData {
                let status = SecItemUpdate(query, NSDictionary(dictionary: [kSecValueData: dictData]))
                os_log("Update status: %{public}ld", log: OSLog.logger, type: .debug, status)
            } else {
                let status = SecItemDelete(query)
                os_log("Delete status: %{public}ld", log: OSLog.logger, type: .debug, status)
            }
        } else {
            if let dictData = objectData {
                query.setValue(dictData, forKey: kSecValueData as String)
                let status = SecItemAdd(query, nil)
                os_log("Update status: %{public}ld", log: OSLog.logger, type: .debug, status)
            }
        }
    }
    
    private func load(withKey key: String) -> Data? {
        let query = keychainQuery(withKey: key)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnAttributes as String)
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query, &result)
        
        guard
            let resultsDict = result as? NSDictionary,
            let resultsData = resultsDict.value(forKey: kSecValueData as String) as? Data,
            status == noErr
            else {
                os_log("Load status: %{public}ld", log: OSLog.logger, type: .debug, status)
                return nil
        }
        return resultsData
    }
    
    private func keychainQuery(withKey key: String) -> NSMutableDictionary {
        let result = NSMutableDictionary()
        result.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
        result.setValue(key, forKey: kSecAttrService as String)
        result.setValue(kSecAttrAccessibleAlwaysThisDeviceOnly, forKey: kSecAttrAccessible as String)
        return result
    }
    
}
