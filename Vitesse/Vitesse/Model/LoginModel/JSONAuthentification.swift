//
//  JSONAuthentification.swift
//  Vitesse
//
//  Created by KEITA on 15/05/2024.
//

import Foundation

struct JsonAuthentification : Decodable {
    var token : String
    var isAdmin : Bool
}
