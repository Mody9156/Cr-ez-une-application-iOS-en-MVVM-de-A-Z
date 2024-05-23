import Foundation

class FetchCandidateProfileViewModel: ObservableObject {
    @Published var candidats: [CandidateInformation] = []
    let candidateProfile: CandidateProfile

    init(candidateProfile: CandidateProfile) {
        self.candidateProfile = candidateProfile
    }
    enum FetchTokenResult: Error, LocalizedError {
        case candidateProfileError,fetchTokenError
    }
//affiche la liste
    func fetchCandidateProfile() async throws -> [CandidateInformation] {
        do {
            let getToken = try fetchToken()
            let data = try await candidateProfile.fetchCandidateSubmission(token: getToken)
            self.candidats = data
            return data
        } catch {
            throw FetchTokenResult.candidateProfileError
        }
    }

    private func fetchToken() throws -> String {
        let token = try Keychain().get(forKey: "token")
        guard let getToken = String(data: token, encoding: .utf8) else {
            throw FetchTokenResult.fetchTokenError
        }
        return getToken
    }
}
