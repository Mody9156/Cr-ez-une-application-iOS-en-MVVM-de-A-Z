import Foundation

class RegisterViewModel: ObservableObject {
    @Published var email: String = "Andrew@gmail.com"
    @Published var password: String = "Modibokeita6582"
    @Published var firstName: String = "Andrew"
    @Published var lastName: String = "Kyrie"
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
            loginViewModel.username = email
        } catch {
            throw error
        }
    }
}
