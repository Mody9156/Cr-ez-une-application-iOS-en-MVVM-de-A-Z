//
//  TokenRetrievable.swift
//  Vitesse
//
//  Created by KEITA on 24/06/2024.
//

import Foundation

protocol TokenRetrievable {
    static func retrieveToken(_ token : String) throws -> String
}
