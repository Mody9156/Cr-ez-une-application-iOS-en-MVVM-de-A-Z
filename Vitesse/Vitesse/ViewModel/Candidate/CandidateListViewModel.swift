import Foundation

enum CandidateManagementError: Error, LocalizedError {
    case displayCandidatesListError, fetchTokenError, deleteCandidateError
    case processCandidateElementsError, createCandidateError
}

class CandidateListViewModel: ObservableObject {
    @Published var candidate: [CandidateInformation] = []
    @Published var retrieveCandidateData: CandidateDataManager
    var keychain : Keychain
    init(retrieveCandidateData: CandidateDataManager,keychain : Keychain )  {
        self.retrieveCandidateData = retrieveCandidateData
        self.keychain = keychain
    }
    
    // Get token
    func retrieveToken() throws -> String {
        let keychain = try Keychain().get(forKey: "token")
        guard let encodingToken = String(data: keychain, encoding: .utf8) else {
            throw CandidateManagementError.fetchTokenError
        }
        return encodingToken
    }
    
    // Fetch candidates list
    @MainActor
    @discardableResult
    func displayCandidatesList() async throws -> [CandidateInformation] {
        do {
            let token = try retrieveToken()
            
            let request = try URLCandidManager.loadCandidatesFromURL(
                url: "http://127.0.0.1:8080/candidate",
                method: "GET",
                token: token
            )
            
            let fetchCandidateData = try await retrieveCandidateData.fetchCandidateData(request: request)
            
            DispatchQueue.main.async {
                self.candidate = fetchCandidateData
            }
            
            return fetchCandidateData
            
        } catch {
            throw CandidateManagementError.displayCandidatesListError
        }
    }
    
    // Delete candidate
    func deleteCandidate(at offsets: IndexSet) async throws -> HTTPURLResponse {
        do {
            let token = try retrieveToken()
            
            var id = ""
            for offset in offsets {
                id = candidate[offset].id
            }
            
            let request = try URLCandidManager.createURLRequest(
                url: "http://127.0.0.1:8080/candidate/\(id)",
                method: "DELETE",
                token: token,
                id: id
            )
            
            let response = try await retrieveCandidateData.validateHTTPResponse(request: request)
            
            // Update the published property on the main thread
            DispatchQueue.main.async {
                self.candidate.remove(atOffsets: offsets)
            }
            
            return response
        } catch {
            throw CandidateManagementError.deleteCandidateError
        }
    }
    
    // Add  candidates in favorite
    @MainActor
    @discardableResult//
    func showFavoriteCandidates(selectedCandidateId: String) async throws -> CandidateInformation {
        do {
            let token = try retrieveToken()
            
            let request = try URLCandidManager.createURLRequest(
                url:"http://127.0.0.1:8080/candidate/\(selectedCandidateId)/favorite",
                method: "PUT",
                token: token,
                id: selectedCandidateId
            )
            
            let response = try await retrieveCandidateData.fetchCandidateDetail(request: request)
            
            
            return response
        } catch {
            throw CandidateManagementError.processCandidateElementsError
        }
    }
    @MainActor
    
    // Remove candidate
    func removeCandidate(at offsets: IndexSet)   {
        Task{
            do {
                let  deleteCandidate = try await deleteCandidate(at: offsets)
                
                
            } catch {
                HTTPURLResponse(
                    url: URL(string: "http://localhost")!,
                    statusCode: 500,
                    httpVersion: nil,
                    headerFields: nil
                )!
            }

            
            
        }
        }
 
}

