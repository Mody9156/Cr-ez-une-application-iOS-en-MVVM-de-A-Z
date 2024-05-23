//
//  CandidateListViewModel.swift
//  Vitesse
//
//  Created by KEITA on 23/05/2024.
//

import Foundation

class CandidateListViewModel : ObservableObject {
    @Published var candidats: [CandidateInformation] = []
    let retrieveCandidateData: retrieveCandidateData

    init(retrieveCandidateData: retrieveCandidateData) {
        self.retrieveCandidateData = retrieveCandidateData
    }
    enum FetchTokenResult: Error, LocalizedError {
        case displayCandidatesListError
        case fetchTokenError
        case deleteCandidateError,processCandidateElementsError
    }
    @MainActor
    // recuperation du token
    private func getToken() throws -> String {
        let token = try Keychain().get(forKey: "token")
        guard let getToken = String(data: token, encoding: .utf8) else {
            throw FetchTokenResult.fetchTokenError
        }
        return getToken
    }
    
    //////////////////////////////////////////
    ///
    func displayCandidatesList() async throws -> [CandidateInformation] {
        do {
            let getToken = try  await getToken()
            let request = try
            
            CandidateManagement.createURLRequesttt(url:"http://127.0.0.1:8080/candidate",method:"GET",token:getToken)
            let data = try await retrieveCandidateData.fetchCandidateDetailsById(request: request)
            
            self.candidats = data
            
            return data
        } catch {
            throw FetchTokenResult.displayCandidatesListError
        }
    }
    
    func deleteCandidate(at offsets: IndexSet) async throws -> HTTPURLResponse {
        do {
            let getToken = try await getToken()
            var id = ""

            for offset in offsets {
                
                 id = candidats[offset].id
               
            }
            let request = try CandidateManagement.createURLRequest(url: "http://127.0.0.1:8080/candidate/\(id)", method: "GET", token: getToken, id: id)
            
            let data = try await retrieveCandidateData.fetchresponse(request: request)
            
            DispatchQueue.main.async {
               
                self.candidats.remove(atOffsets: offsets)
            }
            return data
        } catch {
            throw FetchTokenResult.deleteCandidateError
        }
    }
    
    func removeCandidate(at offsets: IndexSet) {
        Task {
            do {
                let candidate = try await deleteCandidate(at: offsets)
                print("\(candidate)")
                
            } catch {
                throw FetchTokenResult.deleteCandidateError
            }
        }
    }
    
    func showFavoriteCandidates(at offsets: IndexSet) async throws -> [CandidateInformation]{
        do {
            let getToken = try await getToken()
            var id = ""
            for offset in offsets {
                id = candidats[offset].id
            }
            let request =  try CandidateManagement.createURLRequest(url: "http://127.0.0.1:8080/candidate/\(id)/favorite", method: "PUT", token: getToken, id: id)
            let data = try await retrieveCandidateData.fetchCandidateDetailsById(request: request)
                
            return data
            
        } catch {
            print("Erreur dans fetchAndProcessCandidateFavorites: \(error)")
            throw FetchTokenResult.processCandidateElementsError
        }
    }
}
    
    
    

