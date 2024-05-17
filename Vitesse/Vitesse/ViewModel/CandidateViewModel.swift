//
//  CandidateViewModel.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

class CandidateViewModel : ObservableObject{
    @Published var phone : JSONNull? = nil
    @Published var note : JSONNull? = nil
    @Published var id : String = ""
    @Published var firstName : String = ""
    @Published var linkedinURL: JSONNull? = nil
    @Published var isFavorite: Bool
    @Published var email = ""
    @Published var lastName: String = ""
    
    let candidateProfile : CandidateProfile
    let keychain = Keychain()

    
    
    init(phone: JSONNull? = nil, note: JSONNull? = nil, id: String, firstName: String, linkedinURL: JSONNull? = nil, isFavorite: Bool, email: String = "", lastName: String,candidateProfile : CandidateProfile) {
        self.phone = phone
        self.note = note
        self.id = id
        self.firstName = firstName
        self.linkedinURL = linkedinURL
        self.isFavorite = isFavorite
        self.email = email
        self.lastName = lastName
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
   let candidats =  fetchtoken()
    
    let candidats = RecruitTech(phone: candidats.phone, note: candidats.note, id: candidats.id, firstName: candidats.firstName, linkedinURL: candidats.linkedinURL, isFavorite: candidats.isFavorite, email: candidats.email, lastName: candidats.lastName)
    
}
