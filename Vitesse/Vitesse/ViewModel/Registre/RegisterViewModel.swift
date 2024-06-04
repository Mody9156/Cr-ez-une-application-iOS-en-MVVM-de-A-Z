//
//  RegistreViewModel.swift
//  Vitesse
//
//  Created by KEITA on 16/05/2024.
//

import Foundation

class RegisterViewModel : ObservableObject {
    @Published var email : String = ""
    @Published var password : String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    let loginViewModel : LoginViewModel
    
    let registrationRequestBuilder : RegistrationRequestBuilder
    
    init(registrationRequestBuilder: RegistrationRequestBuilder,loginViewModel : LoginViewModel) {
        self.registrationRequestBuilder = registrationRequestBuilder
        self.loginViewModel = loginViewModel
    }
    
    
    func handleRegistrationViewModel() async throws   {
        do{
            let buildRegistrationRequest = try await registrationRequestBuilder.buildRegistrationRequest(email: email, password: password, firstName: firstName, lastName: lastName)
                print("Vous venez d'enregistrer : \(buildRegistrationRequest)")
            loginViewModel.username = email
        }catch{
          throw  error
        }
    }
    
}
