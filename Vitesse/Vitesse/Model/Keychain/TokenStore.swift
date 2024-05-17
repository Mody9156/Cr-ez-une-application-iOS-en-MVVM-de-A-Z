//
//  TokenStore.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

protocol TokenStore {
    func add(_ data : Data) throws
    func get() throws -> Data
    func delete() throws
    
}
