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
    private let registerUser : RegisterUserModel
    
    var onLoginSucceed: (() -> ())

    init(_ callback : @escaping () -> (),registerUser: RegisterUserModel) {
        self.onLoginSucceed = callback
        self.registerUser = registerUser
    }
    enum failure : Error {
        case invalid
    }
    
    @MainActor
    func authentification() async {
     
        do {
              let token =   try await registerUser.authentification(username: username, password: password)
            print("Authentification réussie!")
                onLoginSucceed()
               
            print("voici le resultat : \(token)")
            } catch {
                print("Échec de l'authentification: \(error)")
            }
       
    }
}
