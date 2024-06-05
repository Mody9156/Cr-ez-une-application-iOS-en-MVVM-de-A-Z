import Foundation

class CandidateListViewModel: ObservableObject {
    @Published var candidats: [CandidateInformation]
    let retrieveCandidateData: CandidateDataManager

    init(retrieveCandidateData: CandidateDataManager, candidats: [CandidateInformation]) {
        self.retrieveCandidateData = retrieveCandidateData
        self.candidats = candidats
    }
    
    enum CandidateManagementError: Error, LocalizedError {
        case displayCandidatesListError, fetchTokenError, deleteCandidateError
        case processCandidateElementsError, createCandidateError
    }
    
    @MainActor
    // Get token
    private func token() throws -> String {
        let keychain = try Keychain().get(forKey: "token")
        guard let encodingToken = String(data: keychain, encoding: .utf8) else {
            throw CandidateManagementError.fetchTokenError
        }
        return encodingToken
    }
    
    @MainActor
    func displayCandidatesList() async throws -> [CandidateInformation] {
        do {
            let token = try token()
            
            let request = try CandidateManagement.loadCandidatesFromURL(
                url: "http://127.0.0.1:8080/candidate",
                method: "GET",
                token: token
            )
            
            let fetchCandidateData = try await retrieveCandidateData.fetchCandidateData(request: request)
            
            DispatchQueue.main.async {
                self.candidats = fetchCandidateData
            }
           
            return fetchCandidateData
            
        } catch {
            throw CandidateManagementError.displayCandidatesListError
        }
    }
    
    func deleteCandidate(at offsets: IndexSet) async throws -> HTTPURLResponse {
        do {
            let token = try token()
            
            var id = ""

            for offset in offsets {
                id = candidats[offset].id
            }
            
            let request = try CandidateManagement.createURLRequest(
                url: "http://127.0.0.1:8080/candidate/\(id)",
                method: "DELETE",
                token: token,
                id: id
            )
            
            let validateHTTPResponse = try await retrieveCandidateData.validateHTTPResponse(request: request)
            
            DispatchQueue.main.async {
                self.candidats.remove(atOffsets: offsets)
            }
            
            return validateHTTPResponse
        } catch {
            throw CandidateManagementError.deleteCandidateError
        }
    }
    
    @MainActor
    func showFavoriteCandidates() async throws -> CandidateInformation {
        do {
            let token = try token()
            
            guard let candidate = candidats.first else {
                throw CandidateManagementError.processCandidateElementsError
            }
            
            let id = candidate.id
           
            let request = try CandidateManagement.createURLRequest(
                url: "http://127.0.0.1:8080/candidate/\(id)/favorite",
                method: "PUT",
                token: token,
                id: id
            )
            
            let response = try await retrieveCandidateData.fetchCandidateDetail(request: request)
            print("Favorite status update for the candidate was successful: \(String(describing: response))")
            
            return response
        } catch {
            print("There are errors in function showFavoriteCandidates()")
            throw CandidateManagementError.processCandidateElementsError
        }
    }
    
    func removeCandidate(at offsets: IndexSet) {
        Task {
            do {
                let candidate = try await deleteCandidate(at: offsets)
                print("\(candidate)")
            } catch {
                print("Error deleting candidate: \(error)")
            }
        }
    }
}
