import Foundation
class CandidateDetailsManager: ObservableObject {
    
    @Published var candidats: [CandidateInformation]
    let retrieveCandidateData: retrieveCandidateData

    init(retrieveCandidateData: retrieveCandidateData,candidats: [CandidateInformation]) {
        self.retrieveCandidateData = retrieveCandidateData
        self.candidats = candidats
    }
    
    enum FetchTokenResult: Error, LocalizedError {
        case displayCandidateDetailsError, fetchTokenError, candidateUpdaterError
    }
    
    private func getToken() throws -> String {
            do {
                let token = try Keychain().get(forKey: "token")
                guard let getToken = String(data: token, encoding: .utf8) else {
                    throw FetchTokenResult.fetchTokenError
                }
                return getToken
            } catch {
                print("Erreur lors de la récupération du token : \(error)")
                throw FetchTokenResult.fetchTokenError
            }
        }
    
    func displayCandidateDetails() async throws -> CandidateInformation {
            do {
                let token = try  getToken()
                print("Token récupéré : \(token)")
                
                guard let candidate = candidats.first else {
                    print("Aucun candidat trouvé dans la liste.")
                    throw FetchTokenResult.displayCandidateDetailsError
                }
                
                let id = candidate.id
                print("ID du candidat : \(id)")
                
                let request = try CandidateManagement.createURLRequest(
                    url: "http://127.0.0.1:8080/candidate/\(id)",
                    method: "GET",
                    token: token,
                    id: id
                )
                print("Requête HTTP : \(request)")
                
                let data = try await retrieveCandidateData.fetchCandidateDetaille(request: request)
                print("Données reçues : \(data)")
                
                return data
                
            } catch {
                print("Erreur lors de displayCandidateDetails : \(error)")
                throw FetchTokenResult.displayCandidateDetailsError
            }
        }
          
    
    func candidateUpdater(phone: String?, note: String?, firstName: String, linkedinURL: String?, isFavorite: Bool, email: String, lastName: String, id: String) async throws -> CandidateInformation {
        do {
            let token = try  getToken()
            let request = try CandidateManagement.createURLRequestfornewcandidat(url: "http://127.0.0.1:8080/candidate/\(id)", method: "PUT", token: token, id: id, phone: phone, note: note, firstName: firstName, linkedinURL: linkedinURL, isFavorite: isFavorite, email: email, lastName: lastName)
            let data = try await retrieveCandidateData.fetchCandidateInformation(token: token, id: id, phone: phone, note: note, firstName: firstName, linkedinURL: linkedinURL, isFavorite: isFavorite, email: email, lastName: lastName, request: request)
            return data
        } catch {
            throw FetchTokenResult.candidateUpdaterError
        }
    }
    
    func updateCandidateInformation(with updatedCandidate: CandidateInformation) {
        if let index = candidats.firstIndex(where: { $0.id == updatedCandidate.id }) {
            candidats[index] = updatedCandidate
        }
    }
}
