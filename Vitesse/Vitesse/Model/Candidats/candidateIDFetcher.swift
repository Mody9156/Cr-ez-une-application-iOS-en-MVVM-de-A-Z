//
//  array.swift
//  Vitesse
//
//  Created by KEITA on 22/05/2024.
//

import Foundation

struct candidateIDFetcher: Identifiable, Codable,Hashable{
    let phone, note: String?
    let id, firstName: String
    let linkedinURL: String?
    let isFavorite: Bool
    let email, lastName: String
}
