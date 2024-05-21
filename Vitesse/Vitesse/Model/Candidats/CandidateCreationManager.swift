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
    
    func buildCandidateCreationRequest(token: String, id: String,phone:String?,note:String?,firstName:String,linkedinURL: String?,isFavorite: Bool,email:String,lastName: String) -> URLRequest {
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
    
    
    
    
}
