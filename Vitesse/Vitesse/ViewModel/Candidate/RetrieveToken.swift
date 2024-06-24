//
//  RetrieveToken.swift
//  Vitesse
//
//  Created by KEITA on 24/06/2024.
//

import Foundation

struct RetrieveToken  : TokenRetrievable{
        
    static func retrieveToken(_ token : String) throws -> String {
        guard !token.isEmpty else {
            throw CandidateManagementError.fetchTokenError
        }
        let keychain = try Keychain().get(forKey: token)
        
        if let encodingToken = String(data: keychain, encoding: .utf8)  {
            
            return encodingToken
            
        }else{
            throw CandidateManagementError.fetchTokenError
        }
        
    }
}
