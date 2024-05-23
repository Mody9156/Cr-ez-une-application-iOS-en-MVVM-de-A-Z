//
//  candidateDelete.swift
//  Vitesse
//
//  Created by KEITA on 20/05/2024.
//

import Foundation

class CandidateDelete {//
    
    let httpService: HTTPService
    
    init(httpService: HTTPService = BasicHTTPClient()) {
        self.httpService = httpService
    }
    
    enum URLRequestError: Error {
        case invalidGeToken
        case httpResponseInvalid
    }
    
    func fetchURLRequest(token: String, candidateId: String) -> URLRequest {
        let url = URL(string: "http://127.0.0.1:8080/candidate/\(candidateId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let authHeader = "Bearer " + token
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        return request
    }
    
    func deleteCandidate(token: String, candidateId: String) async throws -> HTTPURLResponse {
        let request = fetchURLRequest(token: token, candidateId: candidateId)
        let (_, response) = try await httpService.request(request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLRequestError.httpResponseInvalid
        }
        return httpResponse
    }
}
