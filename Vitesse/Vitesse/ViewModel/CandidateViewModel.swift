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
    
    func feltchCandidats () async throws {
        let token = try  keychain.get(forKey: "token")
        let getToken = String(data: token, encoding: .utf8)
      
    }
    
    
   
    
    let candidats = RecruitTech(phone: <#T##JSONNull?#>, note: <#T##JSONNull?#>, id: <#T##String#>, firstName: <#T##String#>, linkedinURL: <#T##JSONNull?#>, isFavorite: <#T##Bool#>, email: <#T##String#>, lastName: <#T##String#>)
    
}
