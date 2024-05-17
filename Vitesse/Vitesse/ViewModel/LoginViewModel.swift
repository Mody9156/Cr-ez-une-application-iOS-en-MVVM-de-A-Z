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
         try keychain.add(authenticationResult.token.data(using: .utf8)!, forKey: "token")
        let tokenData = try keychain.get(forKey: "token")
        let tokenString = String(data: tokenData, encoding: .utf8) ?? "Token non valide"
        print("Token récupéré depuis le trousseau : \(tokenString)")
        print("Authentification réussie!")
        print("\(authenticationResult)")
        onLoginSucceed()
        return authenticationResult
    }
}
