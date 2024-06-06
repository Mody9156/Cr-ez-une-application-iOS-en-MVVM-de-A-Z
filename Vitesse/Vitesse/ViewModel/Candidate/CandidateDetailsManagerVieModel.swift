import Foundation

class CandidateDetailsManagerViewModel: ObservableObject {
    @Published var candidats: [CandidateInformation]
    var candidates: CandidateInformation
    let retrieveCandidateData: CandidateDataManager
    var candidateListViewModel: CandidateListViewModel
    
    init(retrieveCandidateData: CandidateDataManager, candidats: [CandidateInformation], candidateListViewModel: CandidateListViewModel,candidates: CandidateInformation) {
        self.retrieveCandidateData = retrieveCandidateData
        self.candidats = candidats
        self.candidateListViewModel = candidateListViewModel
        self.candidates = candidates
    }
    
    enum CandidateManagementError: Error, LocalizedError {
        case displayCandidateDetailsError, fetchTokenError, candidateUpdaterError
    }
   
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

    @MainActor
    func displayCandidateDetails() async throws -> CandidateInformation {
        do {
            let token = try token()
            
            let displayCandidatesList = try await candidateListViewModel.displayCandidatesList()
            var id = candidates.id
          
            let request = try CandidateManagement.createURLRequest(
                url: "http://127.0.0.1:8080/candidate/\(id)",
                method: "GET",
                token: token,
                id: id
            )
            print("request : \(request)")
            let fetchCandidateDetail = try await retrieveCandidateData.fetchCandidateDetail(request: request)
            return fetchCandidateDetail
            
        } catch {
            print("Error during displayCandidateDetails: \(error)")
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
                token: token, id: id, phone: phone, note: note, firstName: firstName,
                linkedinURL: linkedinURL, isFavorite: isFavorite, email: email, lastName: lastName, request: request
            )
            
            return fetchCandidateInformation
        }
    }
    
    func updateCandidateInformation(with updatedCandidate: CandidateInformation) {
        if let index = candidats.firstIndex(where: { $0.id == updatedCandidate.id }) {
            candidats[index] = updatedCandidate
        }
    }
}
