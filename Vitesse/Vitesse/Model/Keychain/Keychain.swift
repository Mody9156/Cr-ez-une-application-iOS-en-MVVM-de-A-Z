//
//  Keychain.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

class Keychain : TokenStore{
    
    private var token : String
    
    init(token: String) {
        self.token = token
    }
    
    enum KeychainError :Error , LocalizedError{
        case insertFailed
        
        var errorDescription : String? {
            switch self {
            case .insertFailed :
                return "Failed to insert item into keychain."
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
    
    func delete(_ element : String ) throws {
        
    }
    
    func add(_ element : String ) throws {
        var array : [String:String] = [:]
        array[element] = element
    }
    
    
}
