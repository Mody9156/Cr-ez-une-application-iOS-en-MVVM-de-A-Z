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
        case invalidToken
    }
    
    @MainActor
    func authenticateUserAndProceed() async throws -> JSONResponseDecodingModel {
        do {
            let authenticate = try await authenticationManager.authenticate(
                username: username,
                password: password)
            print("Authentication successful!")
            
            try keychain.add(authenticate.token, forKey: "token")
            
            onLoginSucceed()
            
            return authenticate
            
        } catch {
            throw AuthViewModelFailure.invalidToken
        }
    }
}
