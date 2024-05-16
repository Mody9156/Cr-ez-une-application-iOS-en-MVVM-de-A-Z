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
    
    let authenticationManager: AuthenticationManager
    var onLoginSucceed: (() -> ())
    
    init(_ callback: @escaping () -> (), authenticationManager: AuthenticationManager = AuthenticationManager()) {
        self.onLoginSucceed = callback
        self.authenticationManager = authenticationManager
    }
    
    @MainActor
    func authenticateUserAndProceed() async throws -> JSONResponseDecodingModel {
        let authenticationResult = try await authenticationManager.authenticate(username: username, password: password)
        print("Authentification réussie!")
        print("\(authenticationResult)")
        onLoginSucceed()
        return authenticationResult
    }
}
