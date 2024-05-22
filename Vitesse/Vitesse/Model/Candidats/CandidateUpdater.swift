//
//  CandidateUpdater.swift
//  Vitesse
//
//  Created by KEITA on 21/05/2024.
//

import Foundation

class CandidateUpdater {
    let httpService: HTTPService

    init(httpService: HTTPService = BasicHTTPClient()) {
        self.httpService = httpService
    }

    enum CandidateFetchError: Error {
        case networkError
    }
    
    func updateCandidateURLRequest(token: String,candidate: String, id: String,phone:String,note:String,firstName:String,linkedinURL: String,isFavorite: Bool,email:String,lastName: String) -> URLRequest {
        
        let url = URL(string: "http://127.0.0.1:8080/candidate/\(candidate)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let data = RecruitTech(phone: phone, note: note, id: id, firstName: firstName, linkedinURL: linkedinURL, isFavorite: isFavorite, email: email, lastName: lastName)
        let body = try? JSONEncoder().encode(data)
        request.httpBody = body
        let authHeader = "Bearer " + token
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        return request
    }
    func fetchCandidateElements(token: String,candidate: String, id: String,phone:String,note:String,firstName:String,linkedinURL: String,isFavorite: Bool,email:String,lastName: String) async throws -> [RecruitTech] {
        do {
            let request = updateCandidateURLRequest(token: token, candidate: candidate, id: id, phone: phone, note: note, firstName: firstName, linkedinURL: linkedinURL, isFavorite: isFavorite, email: email, lastName: lastName)
            let (data, _) = try await httpService.request(request)
            let candidates = try JSONDecoder().decode([RecruitTech].self, from: data)
            return candidates
        } catch {
            throw CandidateFetchError.networkError
        }
    }
}
