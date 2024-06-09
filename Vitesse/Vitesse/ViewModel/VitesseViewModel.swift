import Foundation

class VitesseViewModel: ObservableObject {
    @Published var onLoginSucceed: Bool
    
    private var authenticationManager: AuthenticationManager
    private var registrationRequestBuilder: RegistrationRequestBuilder
    private var retrieveCandidateData: CandidateDataManager
    
    init() {
        self.onLoginSucceed = false
        self.authenticationManager = AuthenticationManager()
        self.registrationRequestBuilder = RegistrationRequestBuilder(httpService: URLSessionHTTPClient())
        self.retrieveCandidateData = CandidateDataManager()
    }
    
    // Lazy instantiation of LoginViewModel
    lazy var loginViewModel: LoginViewModel = {
        LoginViewModel({
            [weak self] in
            DispatchQueue.main.async {
                self?.onLoginSucceed = true
            }
        }, authenticationManager: self.authenticationManager)
    }()
    
    // Lazy instantiation of RegisterViewModel
    lazy var registerViewModel: RegisterViewModel = {
        RegisterViewModel(registrationRequestBuilder: self.registrationRequestBuilder, loginViewModel: self.loginViewModel)
    }()
    
    // Lazy instantiation of CandidateListViewModel
    lazy var candidateListViewModel: CandidateListViewModel = {
        CandidateListViewModel(retrieveCandidateData: self.retrieveCandidateData)
    }()
    
    // Lazy instantiation of CandidateDetailsManagerViewModel
    lazy var candidateDetailsManager: CandidateDetailsManagerViewModel = {
        CandidateDetailsManagerViewModel(retrieveCandidateData: self.retrieveCandidateData, candidats: self.candidateListViewModel.candidats)
    }()
}
