//
//  CandidateViewModel.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

class CandidateViewModel : ObservableObject{
   
    let candidateProfile : CandidateProfile
    let keychain = Keychain()

    
    
    init(candidateProfile : CandidateProfile) {
        
        self.candidateProfile = candidateProfile
    }
    
    enum FetchTokenResult : Error{
        case failure
    }
    
    
    func fetchtoken () async throws -> RecruitTech {
       
            let token = try keychain.get(forKey: "token")
            let getToken = String(data: token, encoding: .utf8)!
            
            try candidateProfile.fetchURLRequest(token: getToken)
            let data = try await candidateProfile.fetchCandidateSubmission(token: getToken)
            print("voici les elements \(data)")
            return data
       
    }
//   let candidats =  fetchtoken()
//    
//    let candidats = RecruitTech(phone: candidats.phone, note: candidats.note, id: candidats.id, firstName: candidats.firstName, linkedinURL: candidats.linkedinURL, isFavorite: candidats.isFavorite, email: candidats.email, lastName: candidats.lastName)
    
}
