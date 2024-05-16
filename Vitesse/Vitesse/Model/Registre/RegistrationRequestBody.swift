//
//  RegistrationRequestBody.swift
//  Vitesse
//
//  Created by KEITA on 16/05/2024.
//

import Foundation

// MARK: - Welcome
struct RegistrationRequestBody: Encodable {
    let email, password, firstName, lastName: String
}
