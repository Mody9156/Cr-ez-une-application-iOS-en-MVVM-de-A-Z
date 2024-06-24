import Foundation

class RegisterViewModel: ObservableObject {
    @Published var email: String = "PetitGros@gmail.com"
    @Published var password: String = "Test123"
    @Published var confirm_password: String = "Test123"
    @Published var firstName: String = "Peter"
    @Published var lastName: String = "PetitGros"
    
    let loginViewModel: LoginViewModel
    var registrationRequestBuilder: RegistrationRequestBuilder
    
    init(registrationRequestBuilder: RegistrationRequestBuilder, loginViewModel: LoginViewModel) {
        self.registrationRequestBuilder = registrationRequestBuilder
        self.loginViewModel = loginViewModel
    }
    
    enum RegisterViewModelError: Error {
        case invalidHandleRegistrationViewModel
        case emailInvalid
        case invalidPassword
        case invalidFirstName
        case invalidLastName
    }
        
    
    func handleRegistrationViewModel() async throws -> RegistrationResponse{
        guard   !email.isEmpty else {
            throw RegisterViewModelError.emailInvalid
        }
        guard  !password.isEmpty else {
            throw RegisterViewModelError.invalidPassword
        }
        guard  !firstName.isEmpty else {
            throw RegisterViewModelError.invalidFirstName
        }
        guard  !lastName.isEmpty else {
            throw RegisterViewModelError.invalidLastName
        }
        
        do {
                        
            _ = try await registrationRequestBuilder.buildRegistrationRequest(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName)
            
            return RegistrationResponse(statusCode: 200, message:  "Registration successful")
            
        } catch {
            throw RegisterViewModelError.invalidHandleRegistrationViewModel
        }
    }
}

struct RegistrationResponse {
    var statusCode: Int
    var message: String
}
