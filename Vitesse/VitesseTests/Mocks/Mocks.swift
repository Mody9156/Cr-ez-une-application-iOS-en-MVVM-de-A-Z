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
        var mockCandidates_array: [CandidateInformation] = []
        var mockCandidates: CandidateInformation?
        var mockResponse: HTTPURLResponse?
        var shouldThrowError: Bool = false
        var errorToThrow: CandidateFetchError?
        
        override func fetchCandidateData(request: URLRequest) async throws -> [CandidateInformation] {
            if shouldThrowError {
                throw errorToThrow ?? CandidateFetchError.fetchCandidateDataError
            }
            return mockCandidates_array
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
        
        override func fetchCandidateDetail(request: URLRequest) async throws   -> CandidateInformation {
            if shouldThrowError {
                throw errorToThrow ?? CandidateFetchError.fetchCandidateDetailError
            }
            
            guard let candidateDetail = mockCandidates else {
                throw CandidateFetchError.fetchCandidateDetailError
            }
            
            return candidateDetail
            
        }
        
        
        override func fetchCandidateInformation(token: String, id: String, phone: String?, note: String?, firstName: String, linkedinURL: String?, isFavorite: Bool, email: String, lastName: String, request: URLRequest) async throws -> CandidateInformation {
            if shouldThrowError {
                throw errorToThrow ?? CandidateFetchError.fetchCandidateInformationError
            }
            guard let candidateInformation =  mockCandidates else {
                throw CandidateFetchError.fetchCandidateDetailError
                
            }
            return candidateInformation
            
        }
    }
    
    class MockKeychain: Keychain {
        var mockTokenData: Data?
        var shouldThrowError: Bool = false
        var errorToThrow: CandidateManagementError?

        enum KeychainError: Error, LocalizedError {
            case getFailed,insertFailure,
                 deleteFailure
            
            var errorDescription: String? {
                switch self {
                case .insertFailure:
                    return "Failed to insert item into keychain."
                case .deleteFailure:
                    return "Failed to delete item from keychain."
                case .getFailed:
                    return "Failed to get item from keychain."
                }
            }
            
        }
      
        
        override func add(_ data: String, forKey key: String) throws {
            mockTokenData = data.data(using: .utf8)
            if shouldThrowError {
                throw errorToThrow ?? CandidateManagementError .fetchTokenError
            }
        }
        
        override func get(forKey key: String) throws -> Data {
            if shouldThrowError {
                throw errorToThrow ?? CandidateManagementError .fetchTokenError
            }
            guard let data = mockTokenData else {
                throw errorToThrow ?? CandidateManagementError .fetchTokenError
            }
            return data
        }
        
        override func delete(forKey key: String) throws {
            if shouldThrowError {
                throw errorToThrow ?? CandidateManagementError .fetchTokenError
            }
            mockTokenData = nil
        }
    }
   
 
    
}
