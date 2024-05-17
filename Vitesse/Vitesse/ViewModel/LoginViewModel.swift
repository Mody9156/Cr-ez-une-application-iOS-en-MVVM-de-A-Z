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
        var storekey = ""
        storekey = authenticationResult.token
        try keychain.add(storekey.data(using: .utf8)!, forkey: "token")
        let getoken = try keychain.get(keychain: "token")
        print("token : \(getoken)")
        print("Authentification réussie!")
        print("\(authenticationResult)")
        onLoginSucceed()
        return authenticationResult
    }
}
