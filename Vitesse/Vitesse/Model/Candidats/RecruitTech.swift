//
//  RecruitTech.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

struct RecruitTech: Identifiable, Codable{
    let phone, note: String?
    let id, firstName: String
    let linkedinURL: String?
    let isFavorite: Bool
    let email, lastName: String
}

