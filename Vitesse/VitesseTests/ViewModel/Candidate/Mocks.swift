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
    
    class MockCandidatesDataManager: CandidateDataManager {
        var mockCandidates: CandidateInformation?
        var mockResponse: HTTPURLResponse?
        var shouldThrowError: Bool = false
        var errorToThrow: CandidateFetchError?
        
        override func fetchCandidateDetail(request: URLRequest) async throws   -> CandidateInformation {
            if shouldThrowError {
                throw errorToThrow ?? CandidateFetchError.fetchCandidateDetailError
            }
            
            guard let candidate = mockCandidates else {
                throw CandidateFetchError.fetchCandidateDetailError
            }
            
            return candidate
            
        }
        
        
        override func fetchCandidateInformation(token: String, id: String, phone: String?, note: String?, firstName: String, linkedinURL: String?, isFavorite: Bool, email: String, lastName: String, request: URLRequest) async throws -> CandidateInformation {
            if shouldThrowError {
                throw errorToThrow ?? CandidateFetchError.fetchCandidateInformationError
            }
            guard let candidate =  mockCandidates else {
                throw CandidateFetchError.fetchCandidateDetailError
                
            }
            return candidate
            
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


    class MockKey: Keychain {
        var mockTokenData: Data?
        
        enum KeychainError: Error, LocalizedError {
            case getFailed,insertError,deleteError
            
            var errorDescription: String? {
                switch self {
                case .insertError:
                    return "Failed to insert item into keychain."
                case .deleteError:
                    return "Failed to delete item from keychain."
                case .getFailed:
                    return "Failed to get item from keychain."
                }
            }
            
        }
        
        override func add(_ data: String, forKey key: String) throws {
            mockTokenData = data.data(using: .utf8)
            print("Mock: Password added to Keychain successfully.")
        }
        
        override func get(forKey key: String) throws -> Data {
            guard let data = mockTokenData else {
                throw KeychainError.getFailed
            }
            print("Mock: Password retrieved from Keychain successfully.")
            return data
        }
        
        override func delete(forKey key: String) throws {
            mockTokenData = nil
            print("Mock: Password deleted from Keychain successfully.")
        }
    }

    
}
