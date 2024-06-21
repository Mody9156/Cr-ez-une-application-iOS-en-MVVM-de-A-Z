//
//  Mocks.swift
//  VitesseTests
//
//  Created by KEITA on 21/06/2024.
//

import Foundation
@testable import Vitesse

enum Mocks {
 
           class MockHTTPServices: HTTPService {
            var mockResult: (Data, HTTPURLResponse)?
            var mockError: Error?
            
            func request(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
                if let error = mockError {
                    throw error
                }
                guard let result = mockResult else {
                    throw NSError(domain: "", code: 0, userInfo: nil)
                }
                return result
            }
        }
    
    
    class MockCandidateDataManager: CandidateDataManager {
        var mockCandidates: [CandidateInformation] = []
        var mockResponse: HTTPURLResponse?
        var shouldThrowError: Bool = false
        var errorToThrow: CandidateFetchError?
        
        override func fetchCandidateData(request: URLRequest) async throws -> [CandidateInformation] {
            if shouldThrowError {
                throw errorToThrow ?? CandidateFetchError.fetchCandidateDataError
            }
            return mockCandidates
        }
        
        override func validateHTTPResponse(request: URLRequest) async throws -> HTTPURLResponse {
            if shouldThrowError {
                throw errorToThrow ?? CandidateFetchError.httpResponseInvalid(statusCode: mockResponse?.statusCode ?? 500)
            }
            guard let response = mockResponse, response.statusCode == 200 else {
                throw CandidateFetchError.httpResponseInvalid(statusCode: mockResponse?.statusCode ?? 500)
            }
            return response
        }
    }


    
}
