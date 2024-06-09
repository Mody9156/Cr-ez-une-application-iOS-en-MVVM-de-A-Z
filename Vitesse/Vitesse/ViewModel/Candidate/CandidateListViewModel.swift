import Foundation

class CandidateListViewModel: ObservableObject {
   @Published var candidats: [CandidateInformation] = []
   @Published  var retrieveCandidateData: CandidateDataManager
    init(retrieveCandidateData: CandidateDataManager) {
        self.retrieveCandidateData = retrieveCandidateData
    }
    
    enum CandidateManagementError: Error, LocalizedError {
        case displayCandidatesListError, fetchTokenError, deleteCandidateError
        case processCandidateElementsError, createCandidateError
    }
    
    // Get token
    private func token() throws -> String {
        let keychain = try Keychain().get(forKey: "token")
        guard let encodingToken = String(data: keychain, encoding: .utf8) else {
            throw CandidateManagementError.fetchTokenError
        }
        return encodingToken
    }
    
    // Fetch candidates list
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
    
    // Delete candidate
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
            
            let response = try await retrieveCandidateData.validateHTTPResponse(request: request)
            
            // Update the published property on the main thread
            DispatchQueue.main.async {
                self.candidats.remove(atOffsets: offsets)
            }
            
            return response
        } catch {
            throw CandidateManagementError.deleteCandidateError
        }
    }
    
    // Add  candidates in favorite
    @MainActor
    func showFavoriteCandidates(selectedCandidateId: String) async throws -> CandidateInformation {
        do {
            let token = try token()
            
            
            let request = try CandidateManagement.createURLRequest(
                url: "http://127.0.0.1:8080/candidate/\(selectedCandidateId)/favorite",
                method: "PUT",
                token: token,
                id: selectedCandidateId
            )
            
            let response = try await retrieveCandidateData.fetchCandidateDetail(request: request)
            print("Favorite status update for the candidate was successful: \(String(describing: response))")
         

            return response
        } catch {
            print("There are errors in function showFavoriteCandidates()")
            throw CandidateManagementError.processCandidateElementsError
        }
    }
    
    // Remove candidate
    func removeCandidate(at offsets: IndexSet) {
        Task {
            do {
                let response = try await deleteCandidate(at: offsets)
                print("\(response)")
            } catch {
                print("Error deleting candidate: \(error)")
            }
        }
    }
}
