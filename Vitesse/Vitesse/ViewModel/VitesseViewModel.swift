import Foundation
import SwiftUI

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
    
    var candidats: CandidatesListView {
        let candidateDelete = CandidateDelete()
        let candidateIDFetcher = CandidateIDFetcher()
        let candidateFavoritesManager = CandidateFavoritesManager()
        
        let candidateViewModel = CandidateViewModel( candidateDelete: candidateDelete, candidateIDFetcher: candidateIDFetcher, candidateFavoritesManager: candidateFavoritesManager)
        let fetchCandidateProfileViewModel = FetchCandidateProfileViewModel(candidateProfile: CandidateProfile())
        
        return CandidatesListView(candidateViewModel: candidateViewModel, fetchCandidateProfileViewModel: fetchCandidateProfileViewModel)
    }
}
