//
//  TokenStore.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

protocol TokenStore {
    func get(_ element : String ) throws -> String
    func delete(_ element : String ) throws
    func add(_ data : Data, forkey key : String) throws
}
