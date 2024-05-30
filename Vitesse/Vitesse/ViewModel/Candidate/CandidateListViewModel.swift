//
//  CandidateListViewModel.swift
//  Vitesse
//
//  Created by KEITA on 23/05/2024.
//

import Foundation

class CandidateListViewModel : ObservableObject {
    @Published var candidates: [CandidateInformation]
    let retrieveCandidateData: CandidateDataManager

    init(retrieveCandidateData: CandidateDataManager,candidates: [CandidateInformation]) {
        self.retrieveCandidateData = retrieveCandidateData
        self.candidates = candidates
    }
    enum CandidateManagementError: Error, LocalizedError {
        case displayCandidatesListError
        case fetchTokenError
        case deleteCandidateError, processCandidateElementsError, createCandidateError
    }
    @MainActor
    // récupération du token
    private func getToken() throws -> String {
        let token = try Keychain().get(forKey: "token")
        guard let getToken = String(data: token, encoding: .utf8) else {
            throw CandidateManagementError.fetchTokenError
        }
        return getToken
    }
    
    @MainActor
    func displayCandidatesList() async throws -> [CandidateInformation] {
        do {
            let getToken = try   getToken()
            let request = try
            
            CandidateManagement.loadCandidatesFromURL(url:"http://127.0.0.1:8080/candidate",method:"GET",token:getToken)
            let data = try await retrieveCandidateData.fetchCandidateData(request: request)
            DispatchQueue.main.async {
                self.candidates = data
            }
            return data
        } catch {
            throw CandidateManagementError.displayCandidatesListError
        }
    }
    
    func deleteCandidate(at offsets: IndexSet) async throws -> HTTPURLResponse {
        do {
            let getToken = try await getToken()
            var id = ""

            for offset in offsets {
                
                 id = candidates[offset].id
               
            }
            let request = try CandidateManagement.createURLRequest(url: "http://127.0.0.1:8080/candidate/\(id)", method: "DELETE", token: getToken, id: id)
            
            let data = try await retrieveCandidateData.validateHTTPResponse(request: request)
            
            DispatchQueue.main.async {
               
                self.candidates.remove(atOffsets: offsets)
            }
            return data
        } catch {
            throw CandidateManagementError.deleteCandidateError
        }
    }
    
    func removeCandidate(at offsets: IndexSet) {
        Task {
            do {
                let candidate = try await deleteCandidate(at: offsets)
                print("\(candidate)")
                
            } catch {
                throw CandidateManagementError.deleteCandidateError
            }
        }
    }
    
    @MainActor
    func showFavoriteCandidates() async throws -> CandidateInformation? {
           do {
               
               let getToken = try  getToken()
                      
               guard let candidate = candidates.first else {
                   throw CandidateManagementError.processCandidateElementsError
                }
                      
               let id = candidate.id
                      
               let url = "http://127.0.0.1:8080/candidate/\(id)/favorite"
                     let request = try CandidateManagement.createURLRequest(url: url, method: "PUT", token: getToken, id: id)
                     
                     let response = try await retrieveCandidateData.fetchCandidateDetail(request: request)
                     print("La mise à jour du statut du favori pour le candidat a réussi. : :\(response)")
                     
                     return response
           } catch {
               throw CandidateManagementError.processCandidateElementsError
           }
       }
}
