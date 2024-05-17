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
        
  
            let authenticationResult = try await authenticationManager.authenticate(username: username, password: password)
           try await testToken()
            print("Authentification réussie!")
            print("\(authenticationResult)")
            onLoginSucceed()
            return authenticationResult
       
       
    }
    
    func testToken() async throws {
        let token = try await authenticationManager.authenticate(username: username, password: password).token
        
        //add new token
       
        do{
            let add = try keychain.add(token, forKey: "token")
            print("Vous venez d'ajouter une nouveau token:\(add)")
            
            let get = try keychain.get(forKey: "token")
            let data = String(data: get, encoding: .utf8)!
            print("Voici votre token sauvegardé \(data) ")
            
            let delete = try keychain.delete(forKey: "token")
            print("Vous venez de supprimer votre token")
            
        }catch{
            print("erreur")
        }
        
        
    }
}
