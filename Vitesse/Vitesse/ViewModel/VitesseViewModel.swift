//
//  VitesseViewModel.swift
//  Vitesse
//
//  Created by KEITA on 14/05/2024.
//

import Foundation

class VitesseViewModel : ObservableObject {
    @Published var onLoginSucceed : Bool
    
    init() {
        onLoginSucceed = false
    }
   
    var loginViewModel: LoginViewModel {
        return LoginViewModel({
            self.onLoginSucceed = true
           }, registerUser: RegisterUserModel())
       }
    
    var candidats: Candidats {
        return Candidats()
    }
    
}

