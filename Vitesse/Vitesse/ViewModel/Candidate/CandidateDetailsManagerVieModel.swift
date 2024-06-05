import Foundation

class CandidateDetailsManagerViewModel: ObservableObject {
    
    @Published var candidats: [CandidateInformation]
    let retrieveCandidateData: CandidateDataManager

    init(retrieveCandidateData: CandidateDataManager, candidats: [CandidateInformation]) {
        self.retrieveCandidateData = retrieveCandidateData
        self.candidats = candidats
    }
    
    enum CandidateManagementError: Error, LocalizedError {
        case displayCandidateDetailsError, fetchTokenError, candidateUpdaterError
    }
    
    // Fonction pour récupérer le token depuis le keychain
    private func token() throws -> String {
        do {
            let keychain = try Keychain().get(forKey: "token")
            
            guard let encodingToken = String(data: keychain, encoding: .utf8) else {
                throw CandidateManagementError.fetchTokenError
            }
            
            return encodingToken
            
        } catch {
            print("Error while retrieving the token: \(error)")
            throw CandidateManagementError.fetchTokenError
        }
    }
    
    // Fonction pour afficher les détails du candidat
    func displayCandidateDetails() async throws -> CandidateInformation {
        do {
            let token = try token()
            print("token : \(token)")
            
            // Assurez-vous qu'il y a au moins un candidat dans la liste
            guard let candidate = candidats.first else {
                print("No candidate found in the list.")
                throw CandidateManagementError.displayCandidateDetailsError
            }
            
            // Récupérer l'ID du candidat
            let id = candidate.id
            print("id : \(id)")
            
            // Créer la requête URL pour récupérer les détails du candidat
            let request = try CandidateManagement.createURLRequest(
                url: "http://127.0.0.1:8080/candidate/\(id)",
                method: "GET",
                token: token,
                id: id
            )
            
            // Récupérer les détails du candidat
            let fetchCandidateDetail = try await retrieveCandidateData.fetchCandidateDetail(request: request)
            return fetchCandidateDetail
            
        } catch {
            print("Error during displayCandidateDetails: \(error)")
            throw CandidateManagementError.displayCandidateDetailsError
        }
    }
    
    // Fonction pour mettre à jour les informations du candidat
    func candidateUpdater(phone: String?, note: String?, firstName: String, linkedinURL: String?, isFavorite: Bool, email: String, lastName: String, id: String) async throws -> CandidateInformation {
        do {
            let token = try token()
            
            let request = try CandidateManagement.createNewCandidateRequest(
                url: "http://127.0.0.1:8080/candidate/\(id)",
                method: "PUT",
                token: token,
                id: id,
                phone: phone,
                note: note,
                firstName: firstName,
                linkedinURL: linkedinURL,
                isFavorite: isFavorite,
                email: email,
                lastName: lastName
            )
            
            let fetchCandidateInformation = try await retrieveCandidateData.fetchCandidateInformation(
                token: token,
                id: id,
                phone: phone,
                note: note,
                firstName: firstName,
                linkedinURL: linkedinURL,
                isFavorite: isFavorite,
                email: email,
                lastName: lastName,
                request: request
            )
            
            return fetchCandidateInformation
        } catch {
            print("Error during candidateUpdater: \(error)")
            throw CandidateManagementError.candidateUpdaterError
        }
    }
    
    // Fonction pour mettre à jour les informations du candidat dans la liste locale
    func updateCandidateInformation(with updatedCandidate: CandidateInformation) {
        if let index = candidats.firstIndex(where: { $0.id == updatedCandidate.id }) {
            candidats[index] = updatedCandidate
        }
    }
}
