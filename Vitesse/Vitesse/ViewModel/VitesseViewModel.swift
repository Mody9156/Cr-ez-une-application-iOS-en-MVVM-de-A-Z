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
        
        return LoginViewModel ({ [weak self] in
        
            self?.onLoginSucceed = true
        },loginModel:LoginModel(httpService: BasicHTTPClient()))
    }
    
    
}

