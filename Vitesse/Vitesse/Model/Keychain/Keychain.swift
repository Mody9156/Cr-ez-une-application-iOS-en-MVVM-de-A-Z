//
//  Keychain.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation
import Security
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
    
  
    
    func add(_ data : Data, forkey key : String) throws {
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
    func get(keychain token : String) throws -> Data {
        let array = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: token,
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
    
    func delete(keychain token : String) throws {
        let array = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: token
        ]  as CFDictionary
        
        guard SecItemDelete(array) == noErr else {
            throw KeychainError.deleteFailed
        }
        
        print("Password deleted from Keychain successfully.")
    }
    
}
