//
//  UserDefaultValue.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import Foundation

@propertyWrapper struct UserDefaultValue<Value:Codable>{
    
    var wrappedValue: Value{
        get{
            let data = storage.data(forKey: key) ?? Data()
            return (try? JSONDecoder().decode(Value.self, from: data)) ?? defaultValue
        }
        set{
            let value = try? JSONEncoder().encode(newValue)
            storage.set(value, forKey: key)
        }
    }
        
    var storage: UserDefaults = .standard
    var key: String
    var defaultValue: Value

    init(storage: UserDefaults = .standard, key: String, defaultValue: Value) {
        self.storage = storage
        self.key = key
        self.defaultValue = defaultValue
    }
    
}

