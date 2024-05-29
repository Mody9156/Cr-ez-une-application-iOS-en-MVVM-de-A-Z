//
//  CandidateDetailsManagerVieModel.swift
//  Vitesse
//
//  Created by KEITA on 23/05/2024.
//

import Foundation

class CandidateDetailsManager : ObservableObject {
    
    @Published var candidats: [CandidateInformation] = []
    let retrieveCandidateData: retrieveCandidateData

    init(retrieveCandidateData: retrieveCandidateData) {
        self.retrieveCandidateData = retrieveCandidateData
    }
    enum FetchTokenResult: Error, LocalizedError {
        case displayCandidateDetailsError,fetchTokenError,candidateUpdaterError
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
    
    func displayCandidateDetails(at offsets: IndexSet) async throws -> [CandidateInformation] {
        do {
            let token = try await getToken()
            var id = ""
            for offset in offsets {
                id = candidats[offset].id
            }
            let request = try CandidateManagement.createURLRequest(url: "http://127.0.0.1:8080/candidate/\(id)", method: "GET", token: token, id: id)
            let data = try await retrieveCandidateData.fetchCandidateData(request: request)
            return data
            
            
        } catch {
            throw FetchTokenResult.displayCandidateDetailsError
        }
    }
    
    func candidateUpdater(phone:String?,note:String?,firstName:String,linkedinURL: String?,isFavorite: Bool,email:String,lastName: String,id:String) async throws -> CandidateInformation  {
        do {
            let getToken = try await getToken()
           
            let request = try CandidateManagement.createURLRequestfornewcandidat(url: "http://127.0.0.1:8080/candidate/\(id)", method: "PUT", token: getToken, id: id, phone: phone, note: note, firstName: firstName, linkedinURL: linkedinURL, isFavorite: isFavorite, email: email, lastName: lastName)
            let data = try await retrieveCandidateData.fetchCandidateInformation(token: getToken, id: id, phone: phone, note: note, firstName: firstName, linkedinURL: linkedinURL, isFavorite: isFavorite, email: email, lastName: lastName, request: request)
           

            return data
        }catch{
            throw FetchTokenResult.candidateUpdaterError
        }
    }
    //add new element in the array
    func updateCandidateInformation(with updatedCandidate: CandidateInformation) {
        if let index = candidats.firstIndex(where: { $0.id == updatedCandidate.id}){
            candidats[index] = updatedCandidate
        }
    }
    
    
}
