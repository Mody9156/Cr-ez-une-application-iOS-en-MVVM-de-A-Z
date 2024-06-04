import Foundation
class CandidateDetailsManagerViewModel: ObservableObject {
    
    @Published var candidats: [CandidateInformation]
    let retrieveCandidateData: CandidateDataManager

    init(retrieveCandidateData: CandidateDataManager,candidats: [CandidateInformation]) {
        self.retrieveCandidateData = retrieveCandidateData
        self.candidats = candidats
    }
    
    enum CandidateManagementError: Error, LocalizedError {
        case displayCandidateDetailsError, fetchTokenError, candidateUpdaterError
    }
    
    private func getToken() throws -> String {
            do {
                let token = try Keychain().get(forKey: "token")
                guard let getToken = String(data: token, encoding: .utf8) else {
                    throw CandidateManagementError.fetchTokenError
                }
                return getToken
            } catch {
                print("Erreur lors de la récupération du token : \(error)")
                throw CandidateManagementError.fetchTokenError
            }
        }
    
    func displayCandidateDetails() async throws -> CandidateInformation {
            do {
                let token = try  getToken()
                
                guard let candidate = candidats.first else {
                    print("Aucun candidat trouvé dans la liste.")
                    throw CandidateManagementError.displayCandidateDetailsError
                }
                
                let id = candidate.id
                
                let request = try CandidateManagement.createURLRequest(
                    url: "http://127.0.0.1:8080/candidate/\(id)",
                    method: "GET",
                    token: token,
                    id: id
                )
                
                let fetchCandidateDetail = try await retrieveCandidateData.fetchCandidateDetail(request: request)
                return fetchCandidateDetail
                
            } catch {
                print("Erreur lors de displayCandidateDetails : \(error)")
                throw CandidateManagementError.displayCandidateDetailsError
            }
        }
          
    
    func candidateUpdater(phone: String?, note: String?, firstName: String, linkedinURL: String?, isFavorite: Bool, email: String, lastName: String, id: String) async throws -> CandidateInformation {
        do {
            let token = try  getToken()
            let request = try CandidateManagement.createNewCandidateRequest(url: "http://127.0.0.1:8080/candidate/\(id)", method: "PUT", token: token, id: id, phone: phone, note: note, firstName: firstName, linkedinURL: linkedinURL, isFavorite: isFavorite, email: email, lastName: lastName)
            let data = try await retrieveCandidateData.fetchCandidateInformation(token: token, id: id, phone: phone, note: note, firstName: firstName, linkedinURL: linkedinURL, isFavorite: isFavorite, email: email, lastName: lastName, request: request)
            
            return data
        } catch {
            throw CandidateManagementError.candidateUpdaterError
        }
    }
    
    func updateCandidateInformation(with updatedCandidate: CandidateInformation) {
        if let index = candidats.firstIndex(where: { $0.id == updatedCandidate.id }) {
            candidats[index] = updatedCandidate
        }
    }
}
