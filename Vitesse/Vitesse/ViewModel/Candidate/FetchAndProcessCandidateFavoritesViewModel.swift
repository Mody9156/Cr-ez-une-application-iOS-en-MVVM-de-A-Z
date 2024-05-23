//
//  fetchAndProcessCandidateFavoritesViewModel.swift
//  Vitesse
//
//  Created by KEITA on 22/05/2024.
//

import Foundation

class FetchAndProcessCandidateFavoritesViewModel : ObservableObject {
    
    let candidateFavoritesManager: CandidateFavoritesManager
    let keychain = Keychain()
    @Published var candidats: [CandidateInformation] = []
    
    init(candidateFavoritesManager: CandidateFavoritesManager){
        self.candidateFavoritesManager = candidateFavoritesManager
    }
    
    enum FetchTokenResult: Error, LocalizedError {
        case fetchTokenError
        case processCandidateElementsError
    }
   
// recuperation du token
    private func fetchToken() throws -> String {
        let token = try keychain.get(forKey: "token")
        guard let getToken = String(data: token, encoding: .utf8) else {
            throw FetchTokenResult.fetchTokenError
        }
        return getToken
    }
  
    
    //Afficher les Favoris
    @MainActor
    func fetchAndProcessCandidateFavorites() async throws -> [CandidateInformation]?   {
        do {
            let getToken = try fetchToken()
            var id = ""
            for candidat in candidats {
                id = candidat.id
            }
            
            let data = try await candidateFavoritesManager.fetchFavoritesURLRequest(token: getToken, candidate: id)
                

            return data
        } catch {
            print("Erreur dans fetchAndProcessCandidateFavorites: \(error)")
            throw FetchTokenResult.processCandidateElementsError
        }
    }
}
