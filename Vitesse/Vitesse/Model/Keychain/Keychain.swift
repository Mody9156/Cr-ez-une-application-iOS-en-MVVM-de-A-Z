//
//  Keychain.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

class Keychain : TokenStore{
  
    
    
    enum KeychainError: Error, LocalizedError {
        case insertFailed, deleteFailed,getFailed
        
        var errorDescription: String? {
            switch self {
            case .insertFailed:
                return "Failed to insert item into keychain."
            case .deleteFailed:
                return "Failed to delete item into keychain."
            case .getFailed:
                return "Failed to get item into keychain."
            }
        }
    }
    
  
    
    func add(_ data : String, forKey key: String) throws {
        
        let recudata = data.data(using: .utf8)!
        
        let array = [
            kSecClass : kSecClassGenericPassword,//spécifie que l'élément est un mot de passe générique
            kSecAttrAccount : key as Any,//spécifie l'attribut de compte (la clé associée aux données).
            kSecValueData : recudata// spécifie les données à insérer
        
        ] as CFDictionary
        
        
        let status = SecItemAdd(array,nil)//est utilisé pour tenter d'ajouter l'élément au trousseau.
        
        guard status == errSecSuccess else {
            throw KeychainError.insertFailed
        }
        print("Password retrieved from Keychain successfully.")

        
    }
    func get(forKey key: String) throws -> Data {
        
        let array : [String : Any] = ([
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount : key,
            kSecReturnData : kCFBooleanTrue as Any,
            kSecMatchLimit : kSecMatchLimitOne,
        ] as CFDictionary) as! [String : Any]
        
        var anyObject: AnyObject?
        let status = SecItemCopyMatching(array as CFDictionary , &anyObject)
        
        guard status == errSecSuccess, let data = anyObject as? Data else {
            throw KeychainError.insertFailed
        }
        print("Password retrieved from Keychain successfully.")
        return data
    }
    
    func delete(forKey key: String) throws {
        let array : [String : Any] = ([
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : key
        ]  as CFDictionary) as! [String : Any]
        
        guard SecItemDelete(array as CFDictionary) == errSecSuccess else {
            throw KeychainError.deleteFailed
        }
        
        print("Password deleted from Keychain successfully.")
    }
    
  
    
    
}
