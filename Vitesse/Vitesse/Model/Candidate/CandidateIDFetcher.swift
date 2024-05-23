//
//  candidateId.swift
//  Vitesse
//
//  Created by KEITA on 20/05/2024.
//

import Foundation

class CandidateIDFetcher {

    let httpService: HTTPService

    init(httpService: HTTPService = BasicHTTPClient()) {
        self.httpService = httpService
    }

    enum CandidateFetchError: Error {
        case networkError
    }

    func getCandidateURLRequest(token: String, candidate: String) -> URLRequest {
        let url = URL(string: "http://127.0.0.1:8080/candidate/\(candidate)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let authHeader = "Bearer " + token
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
       
        return request
    }

    func fetchCandidates(token: String, candidate: String) async throws -> [CandidateInformation] {
        do {
            let request = getCandidateURLRequest(token: token, candidate: candidate)
            let (data, _) = try await httpService.request(request)
            let candidates = try JSONDecoder().decode([CandidateInformation].self, from: data)
           
            return candidates
            
        } catch {
            throw CandidateFetchError.networkError
        }
    }
}
