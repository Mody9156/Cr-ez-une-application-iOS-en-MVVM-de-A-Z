//
//  retrieveCandidateData.swift
//  Vitesse
//
//  Created by KEITA on 23/05/2024.
//
//
//import Foundation
//

import Foundation

class retrieveCandidateData{
    
    let httpService: HTTPService
    
    init(httpService: HTTPService = BasicHTTPClient()) {
        self.httpService = httpService
    }
    
    enum CandidateFetchError: Error {
        case networkError,httpResponseInvalid
    }
    
    func fetchCandidateDetailsById(request : URLRequest) async throws -> [CandidateInformation] {
        do {
            let request =  request
            let (data, _) = try await httpService.request(request)
            let candidates = try JSONDecoder().decode([CandidateInformation].self, from: data)
            return candidates
        }catch{
            throw CandidateFetchError.networkError
        }
        
    }
    
    func fetchCandidateDetails(request : URLRequest) async throws -> [CandidateInformation]? {
        do {
            let request =  request
            let (data, _) = try await httpService.request(request)
            let candidates = try JSONDecoder().decode([CandidateInformation].self, from: data)
            return candidates
        }catch{
            throw CandidateFetchError.networkError
        }
        
    }
    
    func fetchresponse(request : URLRequest) async throws -> HTTPURLResponse {
        
        let request = request
        let (_, response) = try await httpService.request(request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CandidateFetchError.httpResponseInvalid
        }
        return httpResponse
        
        
    }
    
}
