import Foundation

class VitesseViewModel: ObservableObject {
    @Published var onLoginSucceed: Bool
    
    init() {
        self.onLoginSucceed = false
    }
   
    var loginViewModel: LoginViewModel {
        return LoginViewModel({
            [weak self] in
            DispatchQueue.main.async {
                self?.onLoginSucceed = true
            }
        }, authenticationManager: AuthenticationManager())
    }
    
    // Registre
    var registerViewModel: RegisterViewModel {
        let registrationRequestBuilder = RegistrationRequestBuilder(httpService: URLSessionHTTPClient())
        return RegisterViewModel(registrationRequestBuilder: registrationRequestBuilder, loginViewModel: loginViewModel)
    }
    
    var candidateDetailsManager: CandidateDetailsManagerViewModel {
        return CandidateDetailsManagerViewModel(retrieveCandidateData: CandidateDataManager(), candidats: candidateListViewModel.candidates)
    }
    
    var candidateListViewModel: CandidateListViewModel {
        return CandidateListViewModel(retrieveCandidateData: CandidateDataManager(), candidates: [])
    }
}
