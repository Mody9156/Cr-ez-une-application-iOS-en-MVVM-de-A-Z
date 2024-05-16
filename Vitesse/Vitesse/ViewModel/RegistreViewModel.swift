//
//  RegistreViewModel.swift
//  Vitesse
//
//  Created by KEITA on 16/05/2024.
//

import Foundation

class RegistreViewModel : ObservableObject {
    @Published var email : String = "exemple@gmail.com"
    @Published var password : String = "test123"
    @Published var firstName: String = "Jeffersone"
    @Published var lastName: String = "James"
    
    let registrationRequestBuilder : RegistrationRequestBuilder
    
    init(registrationRequestBuilder: RegistrationRequestBuilder) {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.registrationRequestBuilder = registrationRequestBuilder
    }
    
    
    func handleRegistrationViewModel() -> HTTPURLResponse {
        let 
    }
    
}
