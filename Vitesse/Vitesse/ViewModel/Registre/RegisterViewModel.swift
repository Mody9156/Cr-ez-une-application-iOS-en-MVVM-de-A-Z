import Foundation

class RegisterViewModel: ObservableObject {
    @Published var email: String = "exemple22312@gmail.com"
    @Published var password: String = "test12"
    @Published var firstName: String = "Mike"
    @Published var lastName: String = "Joe"
    let loginViewModel: LoginViewModel
    let registrationRequestBuilder: RegistrationRequestBuilder
    
    init(registrationRequestBuilder: RegistrationRequestBuilder, loginViewModel: LoginViewModel) {
        self.registrationRequestBuilder = registrationRequestBuilder
        self.loginViewModel = loginViewModel
    }
    
    func handleRegistrationViewModel() async throws {
        do {
            let buildRegistrationRequest = try await registrationRequestBuilder.buildRegistrationRequest(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName)
            
            print("You have just registered: \(buildRegistrationRequest)")
        } catch {
            throw error
        }
    }
}
