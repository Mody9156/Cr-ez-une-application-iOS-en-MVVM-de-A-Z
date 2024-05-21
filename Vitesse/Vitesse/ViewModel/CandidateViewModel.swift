//
//  CandidateViewModel.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

class CandidateViewModel: ObservableObject {
    let candidateDelete: CandidateDelete
    let candidateProfile: CandidateProfile
    let candidateFavoritesManager : CandidateFavoritesManager
    let keychain = Keychain()
    let candidateIDFetcher : CandidateIDFetcher
    @Published var candidats: [RecruitTech] = []
    
    init(candidateProfile: CandidateProfile, candidateDelete: CandidateDelete,candidateIDFetcher : CandidateIDFetcher,candidateFavoritesManager : CandidateFavoritesManager) {
        self.candidateProfile = candidateProfile
        self.candidateDelete = candidateDelete
        self.candidateIDFetcher = candidateIDFetcher
        self.candidateFavoritesManager = candidateFavoritesManager
        
        Task {
            try await self.candidateProfile()
        }
       
    }
    
    enum FetchTokenResult: Error, LocalizedError {
        case searchCandidateError
        case candidateProfileError
        case deleteCandidateError
        case processCandidateElementsError
    }
    
    @MainActor
    func candidateProfile() async throws -> [RecruitTech] {
        do {
            let token = try keychain.get(forKey: "token")
            let getToken = String(data: token, encoding: .utf8)!
            
            let _ = candidateProfile.fetchURLRequest(token: getToken)
            
            let data = try await candidateProfile.fetchCandidateSubmission(token: getToken)
            DispatchQueue.main.async {
                self.candidats = data
            }
            
            return data
        } catch {
            throw FetchTokenResult.candidateProfileError

        }
    }
    
    func fetchDelete(at offsets: IndexSet) async throws {
        do {
            let token = try self.keychain.get(forKey: "token")
            let getToken = String(data: token, encoding: .utf8)!
            
            for offset in offsets {
                let id = candidats[offset].id
                try await candidateDelete.deleteCandidate(token: getToken, candidateId: id)
            }
            DispatchQueue.main.async {
                self.candidats.remove(atOffsets: offsets)
            }
        } catch {
            throw FetchTokenResult.deleteCandidateError
        }
    }
    
    func deleteCandidate(at offsets: IndexSet) {
        Task {
            do {
                try await fetchDelete(at: offsets)
            } catch {
                throw FetchTokenResult.deleteCandidateError
            }
        }
    }
  //terminer ceci après
    func searchCandidate(at offsets: IndexSet) async throws -> [RecruitTech]{
        do{
            let token = try self.keychain.get(forKey: "token")
            let getToken = String(data: token, encoding: .utf8)!
            var id = ""
            for offset in offsets {
              id = candidats[offset].id
            }
            let candidate = try await candidateIDFetcher.fetchCandidates(token: getToken, candidate: id)
            return candidate
            
        }catch{
            throw FetchTokenResult.searchCandidateError
        }
    }
    
    func processCandidateElements(at offsets : IndexSet) async throws ->  [RecruitTech] {
       
        do{
            let token = try self.keychain.get(forKey: "token")
            let getToken = String(data: token, encoding: .utf8)!
            var id = ""
            for offset in offsets {
                id = candidats[offset].id
            }
            
            let candidate = try await candidateFavoritesManager.fetchFavoritesURLRequest(token: getToken, candidate: id)
            return candidate
            
        }catch{
            throw FetchTokenResult.processCandidateElementsError
        }
    }
}
