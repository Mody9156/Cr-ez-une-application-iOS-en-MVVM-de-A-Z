//
//  Keychain.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation
import Security
class Keychain : TokenStore{
    
    private let key: String

    init(key: String = "com.aura.authtoken") {
        self.key = key
    }
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
    
  
    
    func add(_ data : Data) throws {
        var array = [
            kSecClass : kSecClassGenericPassword,//spécifie que l'élément est un mot de passe générique
            kSecAttrAccount : key as Any,//pécifie l'attribut de compte (la clé associée aux données).
            kSecValueData : data// spécifie les données à insérer
        
        ] as CFDictionary
        
        let status = SecItemAdd(array,nil)//est utilisé pour tenter d'ajouter l'élément au trousseau.
        
        guard status == errSecSuccess else {
            throw KeychainError.insertFailed
        }
        
        
    }
    func get() throws -> Data {
        let array = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as CFDictionary
        
        var anyObject: AnyObject?
        let status = SecItemCopyMatching(array , &anyObject)
        
        guard status == noErr, let data = anyObject as? Data else {
            throw KeychainError.insertFailed
        }
        
        print("Password retrieved from Keychain successfully.")
        return data
    }
    
    func delete() throws {
        let array = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]  as CFDictionary
        
        guard SecItemDelete(array) == noErr else {
            throw KeychainError.deleteFailed
        }
        
        print("Password deleted from Keychain successfully.")
    }
    
  
    
    
}
