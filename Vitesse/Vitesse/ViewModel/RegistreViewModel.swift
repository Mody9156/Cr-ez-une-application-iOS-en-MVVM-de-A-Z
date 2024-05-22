//
//  RegistreViewModel.swift
//  Vitesse
//
//  Created by KEITA on 16/05/2024.
//

import Foundation

class RegistreViewModel : ObservableObject {
    @Published var email : String = "exemple45@gmail.com"
    @Published var password : String = "test123"
    @Published var firstName: String = "jaune"
    @Published var lastName: String = "Pierre"
    
    let registrationRequestBuilder : RegistrationRequestBuilder
    
    init(registrationRequestBuilder: RegistrationRequestBuilder) {
        self.registrationRequestBuilder = registrationRequestBuilder
    }
    
    
    func handleRegistrationViewModel() async throws   {
        do{
            let buildRegistrationRequest = try await registrationRequestBuilder.buildRegistrationRequest(email: email, password: password, firstName: firstName, lastName: lastName)
                print("Vous venez denregistrer : \(buildRegistrationRequest)")
           
        }catch{
          throw  error
        }
    }
    
}
