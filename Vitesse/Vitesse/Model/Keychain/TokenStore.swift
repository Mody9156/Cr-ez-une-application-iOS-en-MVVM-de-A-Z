//
//  TokenStore.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

protocol TokenStore {
    func add(_ data : Data,forKey key: String) throws
    func get(forKey key: String) throws -> Data
    func delete(forKey key: String) throws
    
}
