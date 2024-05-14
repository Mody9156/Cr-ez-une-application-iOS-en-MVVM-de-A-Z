//
//  VitesseViewModel.swift
//  Vitesse
//
//  Created by KEITA on 14/05/2024.
//

import Foundation

class VitesseViewModel : ObservableObject {
    @Published var onLoginSucceed : Bool = false
    
   
    var loginViewModel : LoginViewModel {
        let reistreUserModel = RegisterUserModel(httpService: BasicHTTPClient())
        return LoginViewModel ({ [weak self] in
        
            self?.onLoginSucceed = true
        },registerUser:reistreUserModel)
    }
    
    
}

