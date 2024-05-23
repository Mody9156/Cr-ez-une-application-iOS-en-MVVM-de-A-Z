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
    
    
    var fetchCandidateIDFetcherViewModel: FetchcandidateIDFetcherViewModel {
        return FetchcandidateIDFetcherViewModel(candidateIDFetcher: CandidateIDFetcher(), candidats: [])
    }
    
    var fetchDeleteCandidateViewModel: FetchDeleteCandidateViewModel {
        return FetchDeleteCandidateViewModel(candidateDelete: CandidateDelete())
    }
    
    var fetchAndProcessCandidateFavoritesViewModel: FetchAndProcessCandidateFavoritesViewModel {
        return FetchAndProcessCandidateFavoritesViewModel(candidateFavoritesManager: CandidateFavoritesManager())
    }
    var candidateListViewModel : CandidateListViewModel {
        return CandidateListViewModel(retrieveCandidateData: retrieveCandidateData())
    }
}
