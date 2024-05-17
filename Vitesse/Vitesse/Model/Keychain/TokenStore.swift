//
//  TokenStore.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

protocol TokenStore {
    func add(_ data : Data, forkey key : String) throws
    func get(keychain token : String) throws -> Data
    func delete(keychain token : String) throws
    
}
