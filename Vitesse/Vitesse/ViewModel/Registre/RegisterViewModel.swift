import Foundation

class RegisterViewModel: ObservableObject {
    @Published var email: String = "PetitGros@gmail.com"
    @Published var password: String = "Test123"
    @Published var confirm_password: String = "Test123"
    @Published var firstName: String = "Peter"
    @Published var lastName: String = "PetitGros"
    
    let loginViewModel: LoginViewModel
    let registrationRequestBuilder: RegistrationRequestBuilder
    
    init(registrationRequestBuilder: RegistrationRequestBuilder, loginViewModel: LoginViewModel) {
        self.registrationRequestBuilder = registrationRequestBuilder
        self.loginViewModel = loginViewModel
    }
   
    func handleRegistrationViewModel() async throws {
        do {
            
            _ = try await registrationRequestBuilder.buildRegistrationRequest(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName)
            
        } catch {
            throw error
        }
    }
}
