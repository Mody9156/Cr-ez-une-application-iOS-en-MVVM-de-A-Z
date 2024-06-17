import Foundation

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
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
    
    func textFieldValidatorPassword(_ string: String) -> Bool {
        if string.count < 6 {
            return false
        }
       return true 
    }
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
    enum AuthViewModelFailure: Error {
        case tokenInvalide
    }
    
    // Authenticate user and proceed
    @MainActor
    func authenticateUserAndProceed() async throws -> JSONResponseDecodingModel {
        
        if username.isEmpty {
            message = "Veuillez vérifier l'email ou le nom d'utilisateur"
        } else if password.isEmpty {
            message = "Veuillez entrer un mot de passe valide"
        } else if password.isEmpty && username.isEmpty {
            message = "Veuillez entrer un email/utilisateur et un mot de passe valide"
        } else {
            message = ""
        }
        
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
            throw AuthViewModelFailure.tokenInvalide
        }
    }
}
