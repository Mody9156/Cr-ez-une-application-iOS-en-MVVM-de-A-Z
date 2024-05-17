import Foundation

class Keychain: TokenStore {
    enum KeychainError: Error, LocalizedError {
        case insertFailed, deleteFailed, getFailed
        
        var errorDescription: String? {
            switch self {
            case .insertFailed:
                return "Failed to insert item into keychain."
            case .deleteFailed:
                return "Failed to delete item from keychain."
            case .getFailed:
                return "Failed to get item from keychain."
            }
        }
    }
    
    func add(_ data: String, forKey key: String) throws {
        let recupdata = data.data(using: .utf8)!
        
        try? delete(forKey: key)
        
        
        let array : [String: Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecValueData as String : recupdata
        ]
        
        let status = SecItemAdd(array as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.insertFailed
        }
        
        print("Password added to Keychain successfully.")
    }
    
    func get(forKey key: String) throws -> Data {
        let array: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var anyObject: AnyObject?
        let status = SecItemCopyMatching(array as CFDictionary, &anyObject)
        
        guard status == errSecSuccess, let data = anyObject as? Data else {
            throw KeychainError.getFailed
        }
        
        print("Password retrieved from Keychain successfully.")
        return data
    }
    
    func delete(forKey key: String) throws {
        let array: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        guard SecItemDelete(array as CFDictionary) == errSecSuccess else {
            throw KeychainError.deleteFailed
        }
        
        print("Password deleted from Keychain successfully.")
    }
    
    func testKeychain(token : String) {
        let keychain = Keychain()
        let testToken = token
        
        do {
            // Ajouter le token
            try keychain.add(testToken, forKey: "testTokenKey")
            print("Token ajouté au trousseau.")
            
            // Récupérer le token
            let retrievedData = try keychain.get(forKey: "testTokenKey")
            if let retrievedToken = String(data: retrievedData, encoding: .utf8) {
                print("Token récupéré : \(retrievedToken)")
            } else {
                print("Erreur: Impossible de convertir les données récupérées en chaîne de caractères.")
            }
            
            // Supprimer le token
            try keychain.delete(forKey: "testTokenKey")
            print("Token supprimé du trousseau.")
        } catch {
            print("Erreur Keychain: \(error)")
        }
    }
    
}


