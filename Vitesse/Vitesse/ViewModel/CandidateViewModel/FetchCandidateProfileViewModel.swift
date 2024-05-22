//
//  fetchCandidateProfileViewModel.swift
//  Vitesse
//
//  Created by KEITA on 22/05/2024.
//
import Foundation

class FetchCandidateProfileViewModel: ObservableObject {
    let candidateProfile: CandidateProfile
    let keychain = Keychain()
    @Published var candidats: [RecruitTech] = []

    init(candidateProfile: CandidateProfile) {
        self.candidateProfile = candidateProfile
    }

    enum FetchTokenResult: Error, LocalizedError {
        case candidateProfileError
    }

    @MainActor
    func fetchCandidateProfile() async throws {
        do {
            let getToken = try fetchToken()
            _ = candidateProfile.fetchURLRequest(token: getToken)
            let data = try await candidateProfile.fetchCandidateSubmission(token: getToken)
            self.candidats = data
        } catch {
            throw FetchTokenResult.candidateProfileError
        }
    }

    private func fetchToken() throws -> String {
        let token = try keychain.get(forKey: "token")
        guard let getToken = String(data: token, encoding: .utf8) else {
            throw FetchTokenResult.candidateProfileError
        }
        return getToken
    }
}
