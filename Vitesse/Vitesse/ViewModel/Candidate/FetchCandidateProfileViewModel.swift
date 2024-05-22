import Foundation

class FetchCandidateProfileViewModel: ObservableObject {
    @Published var candidats: [RecruitTech] = []
    let candidateProfile: CandidateProfile

    init(candidateProfile: CandidateProfile) {
        self.candidateProfile = candidateProfile
    }
//affiche la liste
    func fetchCandidateProfile() async throws -> [RecruitTech] {
        do {
            let getToken = try fetchToken()
            let data = try await candidateProfile.fetchCandidateSubmission(token: getToken)
            self.candidats = data
            return data
        } catch {
            throw CandidateViewModel.FetchTokenResult.candidateProfileError
        }
    }

    private func fetchToken() throws -> String {
        let token = try Keychain().get(forKey: "token")
        guard let getToken = String(data: token, encoding: .utf8) else {
            throw CandidateViewModel.FetchTokenResult.candidateProfileError
        }
        return getToken
    }
}
