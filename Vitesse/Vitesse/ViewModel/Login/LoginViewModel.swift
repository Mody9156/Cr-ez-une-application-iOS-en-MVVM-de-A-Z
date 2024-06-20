import Foundation

class LoginViewModel: ObservableObject {
    @Published var username: String = "admin@vitesse.com"
    @Published var password: String = "test123"
    @Published var isLoggedIn: Bool = false
    @Published var message: String = ""
    
    let keychain: Keychain
    let authenticationManager: AuthenticationManager
    var onLoginSucceed: (() -> ())
    
    init(_ callback: @escaping () -> (), authenticationManager: AuthenticationManager = AuthenticationManager(), keychain: Keychain = Keychain()) {
        self.onLoginSucceed = callback
        self.authenticationManager = authenticationManager
        self.keychain = keychain
    }
    
    enum AuthViewModelFailure: Error {
        case tokenInvalid,usernameAndPasswordInvalid
    }
  
    
    // Authenticate user and proceed
    @discardableResult
    @MainActor
    func authenticateUserAndProceed() async throws -> JSONResponseDecodingModel {
        
        do {
            
            // Authenticate user with username and password
            let authenticationResult = try await authenticationManager.authenticate(username: username, password: password)
            
            // Save token in keychain
            try keychain.add(authenticationResult.token, forKey: "token")
            
            // Update login status and call success callback
            self.isLoggedIn = true
            
            onLoginSucceed()
            
            return authenticationResult
            
        } catch {
            
            // Handle authentication error
            throw AuthViewModelFailure.usernameAndPasswordInvalid
        }
        
    }
}
