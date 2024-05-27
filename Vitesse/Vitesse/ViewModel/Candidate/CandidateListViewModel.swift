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
        case deleteCandidateError,processCandidateElementsError,createCandidateError
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
    
    @MainActor
    func displayCandidatesList() async throws -> [CandidateInformation] {
        do {
            let getToken = try   getToken()
            let request = try
            
            CandidateManagement.createURLRequesttt(url:"http://127.0.0.1:8080/candidate",method:"GET",token:getToken)
            let data = try await retrieveCandidateData.fetchCandidateData(request: request)
            DispatchQueue.main.async {
                self.candidats = data
            }
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
            
            let data = try await retrieveCandidateData.validateHTTPResponse(request: request)
            
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
    @MainActor
    func showFavoriteCandidates() async throws -> [CandidateInformation] {
        do {
            let getToken = try getToken()
            var id = ""
            for candidat in candidats {
                id = candidat.id
            }

            let url = "http://127.0.0.1:8080/candidate/\(id)/favorite"
            var request = try CandidateManagement.createURLRequest(url: url, method: "PUT", token: getToken, id: id)
            request.httpBody = Data() // Si nécessaire, vous pouvez ajouter un corps de requête vide
            print("httpMethod : \(String(describing: request.httpMethod))")
            let data = try await retrieveCandidateData.fetchCandidateData(request: request)
            return data
        } catch {
            throw FetchTokenResult.processCandidateElementsError
        }
    }

//    func createCandidate(phone:String?,note:String?,firstName:String,linkedinURL: String?,isFavorite: Bool,email:String,lastName: String,at offsets: IndexSet) async throws -> CandidateInformation {
//        
//        do {
//            let getToken = try await getToken()
//            var id = ""
//            for offset in offsets {
//                id = candidats[offset].id
//            }
//            let request = try CandidateManagement.createURLRequestfornewcandidat(url: "http://127.0.0.1:8080/candidate/", method: "POST", token: getToken, id: id, phone: phone, note: note, firstName: firstName, linkedinURL: linkedinURL, isFavorite: false, email: email, lastName: lastName)
//            let data = try await retrieveCandidateData.fetchCandidateInformation(token: getToken, id: id, phone: phone, note: note, firstName: firstName, linkedinURL: linkedinURL, isFavorite: isFavorite, email: email, lastName: lastName, request: request)
//            return data
//        }catch{
//            throw FetchTokenResult.createCandidateError
//        }
//    }
}
    
    
    

