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
    let keychain = Keychain()
    let candidateIDFetcher : CandidateIDFetcher
    @Published var candidats: [RecruitTech] = []
    
    init(candidateProfile: CandidateProfile, candidateDelete: CandidateDelete,candidateIDFetcher : CandidateIDFetcher) {
        self.candidateProfile = candidateProfile
        self.candidateDelete = candidateDelete
        self.candidateIDFetcher = candidateIDFetcher
        
        Task {
             candidateProfile
        }
       
    }
    
    enum FetchTokenResult: Error, LocalizedError {
        case searchCandidateError
        case keychainError
        case tokenDecodingError
        case candidateProfileRequestError
        case candidateProfileFetchError
        case deleteCandidateError
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
            print("Erreur fetchToken() n'est pas passé")
            throw FetchTokenResult.candidateProfileRequestError
            throw FetchTokenResult.candidateProfileFetchError

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
    
    func searchCandidate(at offsets: IndexSet) async throws -> [RecruitTech]{
        do{
            let token = try self.keychain.get(forKey: "token")
            let getToken = String(data: token, encoding: .utf8)!
            var id : String = ""
            for offset in offsets {
                 id = candidats[offset].id
            }
            
            let candidate = try await candidateIDFetcher.fetchCandidates(token: getToken, candidate: id)
            print("id : \(id)")
            return candidate
            
        }catch{
            throw FetchTokenResult.searchCandidateError
        }
       
      
    }
}
