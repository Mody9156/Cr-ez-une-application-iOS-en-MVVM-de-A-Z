//
//  fetchDeleteCandidateViewModel.swift
//  Vitesse
//
//  Created by KEITA on 22/05/2024.
//

import Foundation

class FetchDeleteCandidateViewModel : ObservableObject {
    let candidateDelete: CandidateDelete
    let keychain = Keychain()
    @Published var candidats: [CandidateInformation] = []

    init(candidateDelete : CandidateDelete) {
        self.candidateDelete =  candidateDelete
    }
    
    enum FetchTokenResult: Error, LocalizedError {
      
        case deleteCandidateError,fetchTokenError
       
    }
    
    // recuperation du token
    private func fetchToken() throws -> String {
        let token = try keychain.get(forKey: "token")
        guard let getToken = String(data: token, encoding: .utf8) else {
            throw FetchTokenResult.fetchTokenError
        }
        return getToken
    }
    
    
    //supprimer les candidats
    func fetchDelete(at offsets: IndexSet) async throws {
        do {
            let getToken = try fetchToken()
            var id = ""

            for offset in offsets {
                
                 id = candidats[offset].id
               
            }
             try await candidateDelete.deleteCandidate(token: getToken, candidateId: id)
            DispatchQueue.main.async {
               
                self.candidats.remove(atOffsets: offsets)
            }
        } catch {
            throw FetchTokenResult.deleteCandidateError
        }
    }
//supprimer les candidats
    func deleteCandidate(at offsets: IndexSet) {
        Task {
            do {
                try await fetchDelete(at: offsets)
            } catch {
                throw FetchTokenResult.deleteCandidateError
            }
        }
    }
}
