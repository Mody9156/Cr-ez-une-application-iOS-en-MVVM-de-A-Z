//
//  RegistreViewModel.swift
//  Vitesse
//
//  Created by KEITA on 16/05/2024.
//

import Foundation

class RegistreViewModel : ObservableObject {
    @Published var email : String = "exemple6@gmail.com"
    @Published var password : String = "test123"
    @Published var firstName: String = "Henry"
    @Published var lastName: String = "Paul"
    
    let registrationRequestBuilder : RegistrationRequestBuilder
    
    init(registrationRequestBuilder: RegistrationRequestBuilder) {
        self.registrationRequestBuilder = registrationRequestBuilder
    }
    
    
    func handleRegistrationViewModel() async throws  -> HTTPURLResponse {
        do{
            let buildRegistrationRequest = try await registrationRequestBuilder.buildRegistrationRequest(email: email, password: password, firstName: firstName, lastName: lastName)
                print("authentification réussie!")
            
            return buildRegistrationRequest
        }catch{
          throw  error
        }
    }
    
}
