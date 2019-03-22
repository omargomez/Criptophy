//
//  UserDefaultsDecorator.swift
//  Criptophy
//
//  Created by Omar Eduardo Gomez Padilla on 3/18/19.
//  Copyright © 2019 Omar Eduardo Gomez Padilla. All rights reserved.
//

import Foundation

public class UserDefaultsDecorator {
    
    private let decorated: UserDefaults
    
    public init(_ decorated: UserDefaults) {
        self.decorated = decorated
    }
    
    // Getters
    
    public func object(forKey: String) -> Any? {
        
        return internalObject(forKey)
    }
    
    private final func internalObject(_ key: String) -> Any? {
        
        guard let encripted = decorated.object(forKey: key) as? Data else {
            return nil
        }
        
        guard let data = Cipher.shared.decrypt(encripted) else {
            return nil
        }
        
        guard let result = data.unarchive(toType: Any.self) else {
            return nil
        }
        
        return result
    
    }
    
    //TODO: Make all final
    public final func float(forKey: String) -> Float {
    
        guard let asNumber = self.internalNumber(forKey) else {
            return 0
        }
        
        return asNumber.floatValue
    }
    
    private final func internalNumber(_ key: String) -> NSNumber? {
        //TODO handle String values
        
        guard let asObj = internalObject(key) else {
            return nil
        }
        
        guard let asNumber = asObj as? NSNumber else {
            return nil
        }
        
        return asNumber
        
    }
    
    public final func double(forKey: String) -> Double {
        
        guard let asNumber = self.internalNumber(forKey) else {
            return 0
        }
        
        return asNumber.doubleValue
    }
    
    public final func bool(forKey: String) -> Bool {
        
        guard let asNumber = self.internalNumber(forKey) else {
            return false
        }
        
        return asNumber.boolValue
    }
    
    public final func integer(forKey: String) -> Int {
        
        guard let asNumber = self.internalNumber(forKey) else {
            return 0
        }
        
        return asNumber.intValue
    }
    
    public final func url(forKey: String) -> URL? {
        
        return self.internalTyped(forKey, URL.self)
        
    }
    
    public final func internalTyped<T>(_ key: String, _ type: T.Type) -> T? {
        
        guard let value = self.internalObject(key) else {
            return nil
        }
        
        return value as? T
    }
    
    public final func array(forKey: String) -> [Any]? {
        
        return self.internalTyped(forKey, Array<Any>.self)
        
    }
    
    public final func dictionary(forKey: String) -> [String : Any]? {
        
        return self.internalTyped(forKey, Dictionary<String,Any>.self)
        
    }
    
    public final func string(forKey: String) -> String? {
        
        guard let value = self.internalObject(forKey) else {
            return nil
        }
        
        return String(describing: value)

    }
    
    public final func stringArray(forKey: String) -> [String]? {
        
        return self.internalTyped(forKey, Array<String>.self)
        
    }
    
    public final func data(forKey: String) -> Data? {
        
        return self.internalTyped(forKey, Data.self)
        
    }
    
    public final func dictionaryRepresentation() -> [String:Any] {
        
        let source = decorated.dictionaryRepresentation()
        
        var result: [String:Any] = [:]
        for k in source.keys {
            if let value = self.internalObject(k) {
                result[k] = value
            }
        }
        
        return result
        
    }
    
    // Setters
    
    public func set(_ value: Any?, forKey: String) {

        guard let value = value else {
            return
        }
        
        self.internalSet(value, forKey: forKey)
    }
    
    private final func internalSet(_ value: Any, forKey: String) {
        
        //TODO: Debug error!!!
        guard let data = Data.archive(value) else {
            return
        }
        
        guard let encripted = Cipher.shared.encrypt(data) else {
            return
        }
        
        decorated.set(encripted, forKey: forKey)
    }
    
    public final func set(_ value: Float, forKey: String) {
        
        self.internalSet(value, forKey: forKey)
        
    }
    
    public final func set(_ value: Double, forKey: String) {
        
        self.internalSet(value, forKey: forKey)
        
    }
    
    public final func set(_ value: Bool, forKey: String) {
        
        self.internalSet(value, forKey: forKey)
        
    }
    
    public final func set(_ value: Int, forKey: String) {
        
        self.internalSet(value, forKey: forKey)
        
    }
    
    public final func set(_ value: URL?, forKey: String) {
        
        guard let value = value else {
            return
        }

        self.internalSet(value, forKey: forKey)

    }
    
}
