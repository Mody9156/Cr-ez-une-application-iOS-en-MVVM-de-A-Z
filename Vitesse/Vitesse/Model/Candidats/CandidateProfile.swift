//
//  Candidats.swift
//  Vitesse
//
//  Created by KEITA on 17/05/2024.
//

import Foundation

class CandidateProfile {
    
    let httpService: HTTPService
    
    init(httpService: HTTPService = BasicHTTPClient()) {
        self.httpService = httpService
    }
    
    enum URLRequestError: Error {
        case invalidGeToken
    }
    
    func fetchURLRequest(token: String) -> URLRequest {
        let url = URL(string: "http://127.0.0.1:8080/candidate")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let authHeader = "Bearer " + token
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchCandidateSubmission(token: String) async throws -> [RecruitTech] {
        do {
            let request = fetchURLRequest(token: token)
            let (data, _) = try await httpService.request(request)
            let candidates = try JSONDecoder().decode([RecruitTech].self, from: data)
            return candidates
        } catch {
            throw URLRequestError.invalidGeToken
        }
    }
}
