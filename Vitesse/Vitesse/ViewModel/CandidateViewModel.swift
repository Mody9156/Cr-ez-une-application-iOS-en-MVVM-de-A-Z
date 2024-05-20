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
    @Published var candidats = [RecruitTech].self
    
    
    init(candidateProfile : CandidateProfile) {
        
        self.candidateProfile = candidateProfile
    }
    
    enum FetchTokenResult : Error{
        case failure
    }
    
    
    func fetchtoken () async throws -> [RecruitTech] {
       
        do{
            let token = try keychain.get(forKey: "token")
            let getToken = String(data: token, encoding: .utf8)!
            
            let fetchURLRequest =  candidateProfile.fetchURLRequest(token: getToken)
            let data = try await candidateProfile.fetchCandidateSubmission(token: getToken)
            print("voici les elements \(data)")
            print("fetchURLRequest : \(String(describing: fetchURLRequest))")
            return data
        }catch{
            print("erreur fetchtoken() n'est pas passé ")
            throw FetchTokenResult.failure
        }
          
       
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
