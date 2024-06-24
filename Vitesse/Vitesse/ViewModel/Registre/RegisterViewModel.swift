import Foundation

class RegisterViewModel: ObservableObject {
    @Published var email: String? = "PetitGros@gmail.com"
    @Published var password: String? = "Test123"
    @Published var confirm_password: String? = "Test123"
    @Published var firstName: String? = "Peter"
    @Published var lastName: String? = "PetitGros"
    
    let loginViewModel: LoginViewModel
    var registrationRequestBuilder: RegistrationRequestBuilder
    
    init(registrationRequestBuilder: RegistrationRequestBuilder, loginViewModel: LoginViewModel) {
        self.registrationRequestBuilder = registrationRequestBuilder
        self.loginViewModel = loginViewModel
    }
    
    enum RegisterViewModelError :Error{
        case invalidHandleRegistrationViewModel
    }
   
    
    func handleRegistrationViewModel() async throws -> RegistrationResponse{
        do {
            guard let email = email, !email.isEmpty else {
                      throw RegisterViewModelError.invalidHandleRegistrationViewModel
                  }
                  guard let password = password, !password.isEmpty else {
                      throw RegisterViewModelError.invalidHandleRegistrationViewModel
                  }
                  guard let firstName = firstName, !firstName.isEmpty else {
                      throw RegisterViewModelError.invalidHandleRegistrationViewModel
                  }
                  guard let lastName = lastName, !lastName.isEmpty else {
                      throw RegisterViewModelError.invalidHandleRegistrationViewModel
                  }
            
            
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
