import Foundation

class CandidateViewModel: ObservableObject {
    let candidateFavoritesManager: CandidateFavoritesManager
    let keychain = Keychain()
    @Published var candidats: [RecruitTech] = []

    init( candidateFavoritesManager: CandidateFavoritesManager) {
        self.candidateFavoritesManager = candidateFavoritesManager
        
        
    }

    enum FetchTokenResult: Error, LocalizedError {
        case searchCandidateError
        case candidateProfileError
        case deleteCandidateError
        case processCandidateElementsError
        case fetchcandidateIDFetcherError
    }
//Afficher la liste des candidats
   
// recuperation du token
    private func fetchToken() throws -> String {
        let token = try keychain.get(forKey: "token")
        guard let getToken = String(data: token, encoding: .utf8) else {
            throw FetchTokenResult.candidateProfileError
        }
        return getToken
    }
    
    // afficher les detailles du candidat

    
    
   
////
//    func searchCandidate(at offsets: IndexSet) async throws -> [RecruitTech] {
//        do {
//            let getToken = try fetchToken()
//            var id = ""
//            for offset in offsets {
//                id = candidats[offset].id
//            }
//            return try await candidateIDFetcher.fetchCandidates(token: getToken, candidate: id)
//        } catch {
//            throw FetchTokenResult.searchCandidateError
//        }
//    }
//Afficher les Favoris
    @MainActor
    func fetchAndProcessCandidateFavorites() async throws -> [RecruitTech]?   {
        do {
            let getToken = try fetchToken()
            var id = ""
            for candidat in candidats {
                id = candidat.id
            }
            
            let data = try await candidateFavoritesManager.fetchFavoritesURLRequest(token: getToken, candidate: id)
                

            return data
        } catch {
            print("Erreur dans fetchAndProcessCandidateFavorites: \(error)")
            throw FetchTokenResult.processCandidateElementsError
        }
    }
}
