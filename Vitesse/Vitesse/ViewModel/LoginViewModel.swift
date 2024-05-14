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
    private let loginModel :  LoginModel
    
    var onLoginSucceed: (() -> ())

    init(_ callback : @escaping () -> (),loginModel: LoginModel) {
        self.onLoginSucceed = callback
        self.loginModel = loginModel
    }
    @MainActor
    func authentification() async throws {
        onLoginSucceed()
    }
}
