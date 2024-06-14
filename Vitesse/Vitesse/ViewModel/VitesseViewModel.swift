import Foundation

class VitesseViewModel: ObservableObject {
    @Published var onLoginSucceed: Bool
    
    init() {
        self.onLoginSucceed = false
    }
    
    // Create and return a new instance of LoginViewModel
    var loginViewModel: LoginViewModel {
        return LoginViewModel({
            [weak self] in
            DispatchQueue.main.async {
                self?.onLoginSucceed = true
            }
        }, authenticationManager: AuthenticationManager())
    }
    
    // Create and return a new instance of RegisterViewModel
    var registerViewModel: RegisterViewModel {
        let registrationRequestBuilder = RegistrationRequestBuilder(httpService: URLSessionHTTPClient())
        return RegisterViewModel(registrationRequestBuilder: registrationRequestBuilder, loginViewModel: loginViewModel)
    }
    
    // Create and return a new instance of CandidateDetailsManagerViewModel
    var candidateDetailsManager: CandidateDetailsManagerViewModel {
        let candidateListVM = candidateListViewModel
        return CandidateDetailsManagerViewModel(retrieveCandidateData: candidateListVM.retrieveCandidateData, candidats: candidateListVM.candidats)
    }
    
    // Create and return a new instance of CandidateListViewModel
    var candidateListViewModel: CandidateListViewModel {
        return CandidateListViewModel(retrieveCandidateData: CandidateDataManager(), keychain: Keychain())
    }
}
