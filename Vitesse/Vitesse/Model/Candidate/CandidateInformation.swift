//
//  RecruitTech.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

struct CandidateInformation: Identifiable, Codable,Hashable{
    var phone, note: String?
    var id, firstName: String
    var linkedinURL: String?
    var isFavorite: Bool
    var email, lastName: String
}

