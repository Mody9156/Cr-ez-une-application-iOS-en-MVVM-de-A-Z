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
    
   
    var loginViewModel : LoginViewModel {
        let reistreUserModel = RegisterUserModel()
        return LoginViewModel ({ [weak self] in
        
            self?.onLoginSucceed = true
            
        },registerUser:reistreUserModel)
    }
    
    var candidats: Candidats {
        return Candidats()
    }
    
    
}

