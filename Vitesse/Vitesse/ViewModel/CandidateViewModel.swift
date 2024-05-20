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
    @Published var candidats : RecruitTech?
    
    
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
    func fetchData(){
        Task{
            do{
                let data = try await fetchtoken()
                DispatchQueue.main.async {
                    self.candidats = data
                }
            }catch{
                print("error ")
            }
        }
    }
   
    
}
