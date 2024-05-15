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
     let registerUser : RegisterUserModel
    
    var onLoginSucceed: (() -> ())

    init(_ callback : @escaping () -> (),registerUser: RegisterUserModel = RegisterUserModel()) {
        self.onLoginSucceed = callback
        self.registerUser = registerUser
    }
    enum failure : Error {
        case invalid
    }
    
    @MainActor
    func authentification() async throws -> (String,Bool) {
     
            let token =  try await registerUser.authentification(username: username, password: password)
            print("Authentification réussie!")
            print("\(token)")
                onLoginSucceed()
            return (token.token,token.isAdmin)

    }
}
