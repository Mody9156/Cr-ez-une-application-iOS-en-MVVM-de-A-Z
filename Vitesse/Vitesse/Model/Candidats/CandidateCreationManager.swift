//
//  CandidateCreationManager.swift
//  Vitesse
//
//  Created by KEITA on 21/05/2024.
//

import Foundation

class CandidateCreationManager {
    let httpService: HTTPService

    init(httpService: HTTPService = BasicHTTPClient()) {
        self.httpService = httpService
    }

    enum CandidateFetchError: Error {
        case networkError
    }
    
    func buildCandidateCreationRequest(token: String, id: String,phone:String,note:String?,firstName:String,linkedinURL: String,isFavorite: Bool,email:String,lastName: String) -> URLRequest {
        let url = URL(string: "http://127.0.0.1:8080/candidate/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let data = RecruitTech(phone: phone, note: note, id: id, firstName: firstName, linkedinURL: linkedinURL, isFavorite: isFavorite, email: email, lastName: lastName)
        let body = try? JSONEncoder().encode(data)
        request.httpBody = body
        let authHeader = "Bearer " + token
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        return request
    }
    
    
    func accessCandidateCreationRequest(token: String, id: String,phone:String,note:String?,firstName:String,linkedinURL: String,isFavorite: Bool,email:String,lastName: String) async throws -> [RecruitTech] {
        
        let (data,_) = try await httpService.request(buildCandidateCreationRequest(token: token, id: id, phone: phone, note: note, firstName: firstName, linkedinURL: linkedinURL, isFavorite: isFavorite, email: email, lastName: lastName))
        
       guard let jsonDecode = try? JSONDecoder().decode([RecruitTech].self, from: data)
        else {
            throw CandidateFetchError.networkError
        }
        return jsonDecode
    }
    
    
    
}
