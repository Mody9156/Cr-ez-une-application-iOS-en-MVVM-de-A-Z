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
    
    var registreViewModel: RegistreViewModel {
        let registrationRequestBuilder = RegistrationRequestBuilder(httpService: BasicHTTPClient())
        return RegistreViewModel(registrationRequestBuilder: registrationRequestBuilder)
    }
//Candidate
    
    var fetchCandidateProfileViewModel : FetchCandidateProfileViewModel {
        return FetchCandidateProfileViewModel(candidateProfile: CandidateProfile())
    }
    
    var fetchcandidateIDFetcherViewModel : FetchcandidateIDFetcherViewModel{
        return FetchcandidateIDFetcherViewModel(candidateIDFetcher: CandidateIDFetcher(), candidats: self.fetchcandidateIDFetcherViewModel.candidats)
    }
    
    var fetchDeleteCandidateViewModel : FetchDeleteCandidateViewModel {
        return FetchDeleteCandidateViewModel(candidateDelete: CandidateDelete())
    }
    
    var fetchAndProcessCandidateFavoritesViewModel : FetchAndProcessCandidateFavoritesViewModel {
        return FetchAndProcessCandidateFavoritesViewModel(candidateFavoritesManager: CandidateFavoritesManager())
    }
}
