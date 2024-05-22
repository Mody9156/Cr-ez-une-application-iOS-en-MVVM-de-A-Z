//
//  fetchcandidateIDFetcherViewModel.swift
//  Vitesse
//
//  Created by KEITA on 22/05/2024.
//

import Foundation

class FetchcandidateIDFetcherViewModel : ObservableObject{
    let candidateIDFetcher: CandidateIDFetcher
    let keychain = Keychain()
    @Published var candidats: [RecruitTech] = []

    init(candidateIDFetcher: CandidateIDFetcher, candidats: [RecruitTech]) {
        self.candidateIDFetcher = candidateIDFetcher
    }
    enum FetchTokenResult: Error, LocalizedError {
        case candidateProfileError,fetchcandidateIDFetcherError
    }
    
    private func fetchToken() throws -> String {
        let token = try keychain.get(forKey: "token")
        guard let getToken = String(data: token, encoding: .utf8) else {
            throw FetchTokenResult.candidateProfileError
        }
        return getToken
    }
    // afficher les detailles du candidat
    func fetchcandidateIDFetcher(at offsets: IndexSet) async throws -> [RecruitTech] {
        do{
            let getToken = try fetchToken()
            var id = ""
            for offset in offsets {
                id = candidats[offset].id
              
            }
            let _ = candidateIDFetcher.getCandidateURLRequest(token: getToken, candidate: id)
         let data = try await candidateIDFetcher.fetchCandidates(token: getToken, candidate: id)
            return data
        }catch{
            throw FetchTokenResult.fetchcandidateIDFetcherError
        }
    }
}


