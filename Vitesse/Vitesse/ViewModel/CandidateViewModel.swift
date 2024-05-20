//
//  CandidateViewModel.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

class CandidateViewModel : ObservableObject{
    var candidateDelete : CandidateDelete
    var candidateProfile : CandidateProfile
    let keychain = Keychain()
    @Published var candidats : [RecruitTech] = []
    
    init(candidateProfile : CandidateProfile,candidateDelete : CandidateDelete) {
        
        self.candidateProfile = candidateProfile
        self.candidateDelete = candidateDelete
        
        Task{
          try await fetchtoken()
        }
        
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
    
    func fetchdelete() async throws  {
        Task{
            do{
                
                let token = try keychain.get(forKey: "token")
                let getToken = String(data: token, encoding: .utf8)!
                
                
                for offset in candidats {
                    try await candidateDelete.deleteCandidate(token: getToken, CandidateId: offset.id)
                    DispatchQueue.main.async {
                        self.candidats.remove(atOffsets: offset.id)
                    }
                    }
               
                
                
            }catch{
                print("erreur fetchdelete() n'est pas passé ")
                throw FetchTokenResult.failure
            }
        }
    }
  
   
    
}
