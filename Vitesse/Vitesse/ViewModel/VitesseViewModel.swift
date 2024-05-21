//
//  VitesseViewModel.swift
//  Vitesse
//
//  Created by KEITA on 14/05/2024.
//

import Foundation

class VitesseViewModel: ObservableObject {
    @Published var onLoginSucceed: Bool
    
    init() {
        onLoginSucceed = false
    }
   
    var loginViewModel: LoginViewModel {
        return LoginViewModel({
            self.onLoginSucceed = true
           }, authenticationManager: AuthenticationManager())
    }
    
    var registreViewModel : RegistreViewModel {
        let registrationRequestBuilder = RegistrationRequestBuilder(httpService: BasicHTTPClient())
        return RegistreViewModel(registrationRequestBuilder: registrationRequestBuilder)
    }
    
    var candidats: CandidatesListView {
       
        let candidateViewModel = CandidateViewModel(candidateProfile: CandidateProfile(), candidateDelete: CandidateDelete())
        
        return CandidatesListView(candidateViewModel:candidateViewModel)
    }
}
