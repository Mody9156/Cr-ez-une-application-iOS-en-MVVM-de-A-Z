import Foundation

class VitesseViewModel: ObservableObject {
    @Published var onLoginSucceed: Bool
    
    init() {
        self.onLoginSucceed = false
    }
   
    var loginViewModel: LoginViewModel {
        return LoginViewModel({[weak self] in
            DispatchQueue.main.async {
                self?.onLoginSucceed = true
            }
        }, authenticationManager: AuthenticationManager())
    }
    
    // Registre
    var registreViewModel: RegisterViewModel {
        let registrationRequestBuilder = RegistrationRequestBuilder(httpService: URLSessionHTTPClient())
        return RegisterViewModel(registrationRequestBuilder: registrationRequestBuilder)
    }
    
    
    var candidateDetailsManager: CandidateDetailsManagerViewModel {
        return CandidateDetailsManagerViewModel(retrieveCandidateData: CandidateDataManager(), candidats: candidateListViewModel.candidats)
    }
    
   
    var candidateListViewModel : CandidateListViewModel {
        return CandidateListViewModel(retrieveCandidateData: CandidateDataManager())
    }
}
