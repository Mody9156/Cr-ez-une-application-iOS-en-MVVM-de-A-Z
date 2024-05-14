//
//  LoginViewModel.swift
//  Vitesse
//
//  Created by KEITA on 14/05/2024.
//

import Foundation

class LoginViewModel : ObservableObject{
    @Published var username : String = "admin@vitesse.com"
    @Published var password : String = "test123"
    
    
    
    func authentification(){
        
    }
}
