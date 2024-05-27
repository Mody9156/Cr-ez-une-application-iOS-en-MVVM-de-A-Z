import Foundation

class VitesseViewModel: ObservableObject {
    @Published var onLoginSucceed: Bool
    
    init() {
        self.onLoginSucceed = false
    }
   
    var loginViewModel: LoginViewModel {
        return LoginViewModel({
            self.onLoginSucceed = true
        }, authenticationManager: AuthenticationManager())
    }
    
    // Registre
    var registreViewModel: RegistreViewModel {
        let registrationRequestBuilder = RegistrationRequestBuilder(httpService: BasicHTTPClient())
        return RegistreViewModel(registrationRequestBuilder: registrationRequestBuilder)
    }
    
    
    var candidateDetailsManager: CandidateDetailsManager {
        return CandidateDetailsManager(retrieveCandidateData: retrieveCandidateData())
    }
    
   
    var candidateListViewModel : CandidateListViewModel {
        return CandidateListViewModel(retrieveCandidateData: retrieveCandidateData())
    }
}
