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
    
    
    func get(_ element : String ) throws -> String {
         
        
    }
    
    func delete(_ element : String ) throws {
        
    }
    
    func add(_ element : String ) throws {
        var array : [String:String] = [:]
        array.
    }
    
    
}
