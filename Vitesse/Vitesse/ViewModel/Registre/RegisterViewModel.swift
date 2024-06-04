import Foundation

class RegisterViewModel: ObservableObject {
    @Published var email: String = "gaemodibo.keita4@gmail.com"
    @Published var password: String = "test123"
    @Published var firstName: String = "modibo"
    @Published var lastName: String = "keita"
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
