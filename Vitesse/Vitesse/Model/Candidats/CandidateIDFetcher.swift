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
        print("\(authHeader)")
        print("\(request)")
        print("\(url)")


        return request
    }

    func fetchCandidates(token: String, candidate: String) async throws -> [RecruitTech] {
        do {
            let request = getCandidateURLRequest(token: token, candidate: candidate)
            let (data, _) = try await httpService.request(request)
            let candidates = try JSONDecoder().decode([RecruitTech].self, from: data)
            print("\(candidates)")
            print("\(request)")
            print("\(data)")
            return candidates
            
        } catch {
            throw CandidateFetchError.networkError
        }
    }
}
