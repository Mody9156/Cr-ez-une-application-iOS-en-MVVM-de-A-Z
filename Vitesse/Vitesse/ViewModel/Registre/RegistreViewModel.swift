//
//  RegistreViewModel.swift
//  Vitesse
//
//  Created by KEITA on 16/05/2024.
//

import Foundation

class RegistreViewModel : ObservableObject {
    @Published var email : String = "exemplenuméro1@gmail.com"
    @Published var password : String = "test123"
    @Published var firstName: String = "max"
    @Published var lastName: String = "Jean"
    
    let registrationRequestBuilder : RegistrationRequestBuilder
    
    init(registrationRequestBuilder: RegistrationRequestBuilder) {
        self.registrationRequestBuilder = registrationRequestBuilder
    }
    
    
    func handleRegistrationViewModel() async throws   {
        do{
            let buildRegistrationRequest = try await registrationRequestBuilder.buildRegistrationRequest(email: email, password: password, firstName: firstName, lastName: lastName)
                print("Vous venez d'enregistrer : \(buildRegistrationRequest)")
           
        }catch{
          throw  error
        }
    }
    
}
