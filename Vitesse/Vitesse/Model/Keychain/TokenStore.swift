//
//  TokenStore.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

protocol TokenStore {
    func get(_ data : String) throws
    func delete() throws
    func add() throws
}
