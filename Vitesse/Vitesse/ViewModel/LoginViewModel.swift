//
//  LoginViewModel.swift
//  Vitesse
//
//  Created by KEITA on 14/05/2024.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var username: String = "admin@vitesse.com"
    @Published var password: String = "test123"
    let keychain = Keychain()
    let authenticationManager: AuthenticationManager
    var onLoginSucceed: (() -> ())
    
    init(_ callback: @escaping () -> (), authenticationManager: AuthenticationManager = AuthenticationManager()) {
        self.onLoginSucceed = callback
        self.authenticationManager = authenticationManager
    }
    enum AuthViewModelFailure: Error {
        case tokenInvalide
    }
    
    @MainActor
    func authenticateUserAndProceed() async throws -> JSONResponseDecodingModel {
        do{
            let authenticationResult = try await authenticationManager.authenticate(username: username, password: password)
                print("Authentification réussie!")
                print("\(authenticationResult.isAdmin)")
                
                try keychain.add(authenticationResult.token, forKey: "token")
                onLoginSucceed()
            
                return authenticationResult
               
        }catch{
            throw AuthViewModelFailure.tokenInvalide
        }
        
       
    }
   
}

