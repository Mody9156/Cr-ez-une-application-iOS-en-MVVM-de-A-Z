//
//  CandidateFavoritesManager.swift
//  Vitesse
//
//  Created by KEITA on 21/05/2024.
//

import Foundation

class CandidateFavoritesManager {
    let httpService: HTTPService

    init(httpService: HTTPService = BasicHTTPClient()) {
        self.httpService = httpService
    }

    enum CandidateFetchError: Error {
        case networkError
    }
    
    func favoritesURLRequest(token: String, candidate: String) -> URLRequest {
        
        let url = URL(string: "http://127.0.0.1:8080/candidate/\(candidate)/favorite")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let authHeader = "Bearer " + token
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchFavoritesURLRequest(token: String, candidate: String) async throws -> [RecruitTech] {
        do {
            let request = favoritesURLRequest(token: token, candidate: candidate)
            let (data, _) = try await httpService.request(request)
            let candidates = try JSONDecoder().decode([RecruitTech].self, from: data)
            return candidates
        } catch {
            throw CandidateFetchError.networkError
        }
    }
}
