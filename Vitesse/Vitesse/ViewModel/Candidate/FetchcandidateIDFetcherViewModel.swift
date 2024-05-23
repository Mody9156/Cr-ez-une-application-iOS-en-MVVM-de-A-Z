//
//  fetchcandidateIDFetcherViewModel.swift
//  Vitesse
//
//  Created by KEITA on 22/05/2024.
//
import Foundation

class FetchcandidateIDFetcherViewModel: ObservableObject {
    @Published var candidats: [CandidateInformation] = []

    let candidateIDFetcher: CandidateIDFetcher
    let keychain = Keychain()

    init(candidateIDFetcher: CandidateIDFetcher, candidats: [CandidateInformation] = []) {
        self.candidateIDFetcher = candidateIDFetcher
        self.candidats = candidats
    }

    enum FetchTokenResult: Error, LocalizedError {
        case candidateProfileError, fetchcandidateIDFetcherError
    }

    private func fetchToken() throws -> String {
        let token = try keychain.get(forKey: "token")
        guard let getToken = String(data: token, encoding: .utf8) else {
            throw FetchTokenResult.candidateProfileError
        }
        return getToken
    }

    // Afficher les détails du candidat
    func fetchCandidateIDFetcher(at offsets: IndexSet) async throws -> [CandidateInformation] {
        do {
            let token = try fetchToken()
            var id = ""
            for offset in offsets {
                id = candidats[offset].id
            }
            let _ = candidateIDFetcher.getCandidateURLRequest(token: token, candidate: id)
            let data = try await candidateIDFetcher.fetchCandidates(token: token, candidate: id)
            return data
        } catch {
            throw FetchTokenResult.fetchcandidateIDFetcherError
        }
    }
}
