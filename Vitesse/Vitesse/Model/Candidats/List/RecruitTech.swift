//
//  RecruitTech.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

struct RecruitTech: Identifiable, Codable,Hashable{
    var phone : String
    var note: String?
    var id, firstName: String
    var linkedinURL: String
    var isFavorite: Bool
    var email, lastName: String
}

