//
//  Cipher.swift
//
//  Created by Omar Eduardo Gomez Padilla on 1/15/19.
//  Copyright © 2019 Omar Eduardo Gomez Padilla. All rights reserved.
//
//  Crypto utility transparently storing keys on the keychain
//

import Foundation
import os.log

public class Cipher {
    
    public static let shared = Cipher()
    
    private let crypter: AES256Crypter?
    
    private init() {
        
        if let pwd = Keychain.shared["KeychainCrypto.pwd"],
            let salt = Keychain.shared["KeychainCrypto.salt"],
            let iv = Keychain.shared["KeychainCrypto.iv"] {
            
            do {
                let key = try AES256Crypter.createKey(password: pwd, salt: salt)
                crypter = try AES256Crypter(key: key, iv: iv)
                
            } catch {
                crypter = nil
            }

        } else {
            // build them
            let salt = AES256Crypter.randomSalt()
            let iv = AES256Crypter.randomIv()
            let pwd = AES256Crypter.randomData(length: 32)
            
            Keychain.shared["KeychainCrypto.pwd"] = pwd
            Keychain.shared["KeychainCrypto.salt"] = salt
            Keychain.shared["KeychainCrypto.iv"] = iv
            
            do {
                let key = try AES256Crypter.createKey(password: pwd, salt: salt)
                crypter = try AES256Crypter(key: key, iv: iv)
                
            } catch {
                crypter = nil
            }
            
        }
        
        if crypter == nil {
            os_log("AES256Crypter instance not created!!!", log: OSLog.logger, type: .error)
        }

    }
    
    public func encrypt(_ data: Data) -> Data? {
        
        guard let crypter = crypter else {
            os_log("AES256Crypter instance not available!!!", log: OSLog.logger, type: .error)
            return nil
        }
        
        do {
            let result = try crypter.encrypt(data)
            return result
        } catch {
            return nil
        }
    }
    
    public func decrypt(_ data: Data) -> Data? {
        guard let crypter = crypter else {
            os_log("AES256Crypter instance not available!!!", log: OSLog.logger, type: .error)
            return nil
        }
        
        do {
            let result = try crypter.decrypt(data)
            return result
        } catch {
            return nil
        }
    }

}
