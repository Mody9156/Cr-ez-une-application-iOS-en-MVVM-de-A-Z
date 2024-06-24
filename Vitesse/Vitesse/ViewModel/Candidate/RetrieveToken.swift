//
//  RetrieveToken.swift
//  Vitesse
//
//  Created by KEITA on 24/06/2024.
//

import Foundation

enum RetrieveToken {
   static func retrieveToken() throws -> String {
        let keychain = try Keychain().get(forKey: "token")
        if let encodingToken = String(data: keychain, encoding: .utf8)  {
            
            return encodingToken
            
        }else{
            throw CandidateManagementError.fetchTokenError
        }
        
    }
}
