import Foundation

class CandidateDetailsManagerViewModel: ObservableObject {
    @Published var candidats: [CandidateInformation]
    @Published var retrieveCandidateData: CandidateDataManager
    @Published var selectedCandidateId: String?

    init(retrieveCandidateData: CandidateDataManager, candidats: [CandidateInformation]) {
        self.retrieveCandidateData = retrieveCandidateData
        self.candidats = candidats
    }
    
    enum CandidateManagementError: Error, LocalizedError {
        case displayCandidateDetailsError, fetchTokenError, candidateUpdaterError
    }
   
    private func token() throws -> String {
        let keychain = try Keychain().get(forKey: "token")
        guard let encodingToken = String(data: keychain, encoding: .utf8) else {
            throw CandidateManagementError.fetchTokenError
        }
        return encodingToken
    }

    @MainActor
    func displayCandidateDetails() async throws -> CandidateInformation {
        guard let selectedCandidateId = selectedCandidateId else {
            throw CandidateManagementError.displayCandidateDetailsError
        }
        
        do {
            let token = try token()
            let request = try CandidateManagement.createURLRequest(
                url: "http://127.0.0.1:8080/candidate/\(selectedCandidateId)",
                method: "GET",
                token: token,
                id: selectedCandidateId
            )
            
            let fetchCandidateDetail = try await retrieveCandidateData.fetchCandidateDetail(request: request)

            return fetchCandidateDetail
        } catch {
            throw CandidateManagementError.displayCandidateDetailsError
        }
    }

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
            throw CandidateManagementError.candidateUpdaterError
        }
    }
    
    func updateCandidateInformation(with updatedCandidate: CandidateInformation) {
        if let index = candidats.firstIndex(where: { $0.id == updatedCandidate.id }) {
            candidats[index] = updatedCandidate
        }
    }
}
