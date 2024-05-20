//
//  CandidateViewModel.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

class CandidateViewModel : ObservableObject{
   
    var candidateProfile : CandidateProfile
    let keychain = Keychain()
    @Published var candidats : [RecruitTech] = []
    
    
    init(candidateProfile : CandidateProfile) {
        
        self.candidateProfile = candidateProfile
    }
    
    enum FetchTokenResult : Error{
        case failure
    }
    
    @MainActor
    func fetchtoken () async throws -> [RecruitTech] {
       
        do{
            let token = try keychain.get(forKey: "token")
            let getToken = String(data: token, encoding: .utf8)!
            
            let _ =  candidateProfile.fetchURLRequest(token: getToken)
            let data = try await candidateProfile.fetchCandidateSubmission(token: getToken)
            DispatchQueue.main.async {
                self.candidats = data

            }
            return data
        }catch{
            print("erreur fetchtoken() n'est pas passé ")
            throw FetchTokenResult.failure
        }
          
       
    }
    
  
   
    
}
