//
//  CandidateListViewModel.swift
//  Vitesse
//
//  Created by KEITA on 23/05/2024.
//

import Foundation

class CandidateListViewModel : ObservableObject {
    @Published var candidats: [CandidateInformation] = []
    let retrieveCandidateData: retrieveCandidateData

    init(retrieveCandidateData: retrieveCandidateData) {
        self.retrieveCandidateData = retrieveCandidateData
    }
    enum FetchTokenResult: Error, LocalizedError {
        case candidateProfileError,fetchTokenError
    }
    @MainActor
    // recuperation du token
    private func fetchToken() throws -> String {
        let token = try Keychain().get(forKey: "token")
        guard let getToken = String(data: token, encoding: .utf8) else {
            throw FetchTokenResult.fetchTokenError
        }
        return getToken
    }
    
    //////////////////////////////////////////
    ///
    func displayCandidatesList() async throws -> [CandidateInformation] {
        do {
            let getToken = try  await fetchToken()
            let request = try
            
            CandidateManagement.createURLRequesttt(url:"http://127.0.0.1:8080/candidate",method:"GET",token:getToken)
            let data = try await retrieveCandidateData.fetchCandidateDetailsById(request: request)
            
            self.candidats = data
            
            return data
        } catch {
            throw FetchTokenResult.candidateProfileError
        }
    }
    
    
    
    
    
}
