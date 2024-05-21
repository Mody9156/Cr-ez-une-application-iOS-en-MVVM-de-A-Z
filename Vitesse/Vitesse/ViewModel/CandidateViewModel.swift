import Foundation

class CandidateViewModel: ObservableObject {
    let candidateDelete: CandidateDelete
    let candidateProfile: CandidateProfile
    let candidateFavoritesManager: CandidateFavoritesManager
    let keychain = Keychain()
    let candidateIDFetcher: CandidateIDFetcher
    @Published var candidats: [RecruitTech] = []

    init(candidateProfile: CandidateProfile, candidateDelete: CandidateDelete, candidateIDFetcher: CandidateIDFetcher, candidateFavoritesManager: CandidateFavoritesManager) {
        self.candidateProfile = candidateProfile
        self.candidateDelete = candidateDelete
        self.candidateIDFetcher = candidateIDFetcher
        self.candidateFavoritesManager = candidateFavoritesManager
        
        Task {
            try await fetchCandidateProfile()
        }
    }

    enum FetchTokenResult: Error, LocalizedError {
        case searchCandidateError
        case candidateProfileError
        case deleteCandidateError
        case processCandidateElementsError
    }

    @MainActor
    func fetchCandidateProfile() async throws -> [RecruitTech] {
        do {
            let getToken = try fetchToken()
            _ = candidateProfile.fetchURLRequest(token: getToken)
            let data = try await candidateProfile.fetchCandidateSubmission(token: getToken)
            self.candidats = data
            return data
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

    func fetchDelete(at offsets: IndexSet) async throws {
        do {
            let getToken = try fetchToken()
            for offset in offsets {
                let id = candidats[offset].id
                try await candidateDelete.deleteCandidate(token: getToken, candidateId: id)
            }
            DispatchQueue.main.async {
                self.candidats.remove(atOffsets: offsets)
            }
        } catch {
            throw FetchTokenResult.deleteCandidateError
        }
    }

    func deleteCandidate(at offsets: IndexSet) {
        Task {
            do {
                try await fetchDelete(at: offsets)
            } catch {
                throw FetchTokenResult.deleteCandidateError
            }
        }
    }

    func searchCandidate(at offsets: IndexSet) async throws -> [RecruitTech] {
        do {
            let getToken = try fetchToken()
            var id = ""
            for offset in offsets {
                id = candidats[offset].id
            }
            return try await candidateIDFetcher.fetchCandidates(token: getToken, candidate: id)
        } catch {
            throw FetchTokenResult.searchCandidateError
        }
    }

    @MainActor
    func fetchAndProcessCandidateFavorites(at offsets: IndexSet) async throws -> [RecruitTech] {
        do {
            let getToken = try fetchToken()
            var id = ""
            for offset in offsets {
                id = candidats[offset].id
            }
            
            print("Token: \(getToken), Candidate ID: \(id)")
            
            let data = try await candidateFavoritesManager.fetchFavoritesURLRequest(token: getToken, candidate: id)

            print("Fetched Data: \(data)")

            return data
        } catch {
            print("Erreur dans fetchAndProcessCandidateFavorites: \(error)")
            throw FetchTokenResult.processCandidateElementsError
        }
    }
}
