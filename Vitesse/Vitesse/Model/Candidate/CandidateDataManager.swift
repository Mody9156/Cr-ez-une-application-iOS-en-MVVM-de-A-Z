//
//  retrieveCandidateData.swift
//  Vitesse
//
//  Created by KEITA on 23/05/2024.
//

import Foundation

class CandidateDataManager {
    
    let httpService: HTTPService
    
    init(httpService: HTTPService = URLSessionHTTPClient()) {
        self.httpService = httpService
    }
    
    enum CandidateFetchError: Error {
        case httpResponseInvalid, fetchCandidateDataError
        case fetchCandidateDetailleError, fetchCandidateInformationError
    }
    
    func fetchCandidateData(request: URLRequest) async throws -> [CandidateInformation] {
        do {
            let (data, _) = try await httpService.request(request)
            let candidates = try JSONDecoder().decode([CandidateInformation].self, from: data)
            return candidates
        } catch {
            throw CandidateFetchError.fetchCandidateDataError
        }
    }
    
    func fetchCandidateDetaille(request: URLRequest) async throws -> CandidateInformation {
        do {
            let (data, _) = try await httpService.request(request)
            let candidate = try JSONDecoder().decode(CandidateInformation.self, from: data)
            return candidate
        } catch {
            throw CandidateFetchError.fetchCandidateDetailleError
        }
    }
    
    func validateHTTPResponse(request: URLRequest) async throws -> HTTPURLResponse {
        let (_, response) = try await httpService.request(request)
        guard response.statusCode == 200 else {
            throw CandidateFetchError.httpResponseInvalid
        }
        return response
    }
    
    func fetchCandidateInformation(token: String, id: String, phone: String?, note: String?, firstName: String, linkedinURL: String?, isFavorite: Bool, email: String, lastName: String, request: URLRequest) async throws -> CandidateInformation {
        let (data, _) = try await httpService.request(request)
        guard let candidate = try? JSONDecoder().decode(CandidateInformation.self, from: data) else {
            throw CandidateFetchError.fetchCandidateInformationError
        }
        return candidate
    }
}
