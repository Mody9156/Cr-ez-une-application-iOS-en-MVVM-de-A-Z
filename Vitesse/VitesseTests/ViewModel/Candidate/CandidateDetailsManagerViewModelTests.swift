//
//  CandidateDetailsManagerViewModelTests.swift
//  VitesseTests
//
//  Created by KEITA on 18/06/2024.
//

import XCTest
@testable import Vitesse

final class CandidateDetailsManagerViewModelTests: XCTestCase {
    
    var candidateDetailsManagerViewModel : CandidateDetailsManagerViewModel!

    
    override func setUp() {
        candidateDetailsManagerViewModel = CandidateDetailsManagerViewModel(retrieveCandidateData: CandidateDataManager(httpService: MockHTTPpServicee()), keychain: MockToken())
        super.setUp()
    }
    
    override func tearDown() {
        candidateDetailsManagerViewModel = nil
        super.setUp()
    }

    func test_token() throws {
        // Given
        let mockTokenString = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFkbWluQHZpdGVzc2UuY29tIiwiaXNBZG1pbiI6dHJ1ZX0.J83TqjxRzmuDuruBChNT8sMg5tfRi5iQ6tUlqJb3M9U"
        let mockTokenData = mockTokenString.data(using: .utf8)!
        let mockKey = MockToken()
        mockKey.mockTokenData = mockTokenData
        candidateDetailsManagerViewModel.keychain = mockKey
        
        do{
            let token = try candidateDetailsManagerViewModel.token()
            
        }catch let error as Keychain.KeychainError{
            XCTAssertEqual(error, .insertFailed)
        }
    }
    
    func testTokenFail() async throws {
        // Given
        let mockKey = MockToken()
        mockKey.mockTokenData = Data([0xFF, 0xFE]) // Invalid UTF-8
        candidateDetailsManagerViewModel.keychain = mockKey
        
        // When && Then
        do {
            _ = try candidateDetailsManagerViewModel.token()
        } catch let error as CandidateDetailsManagerViewModel.CandidateManagementError {
            XCTAssertEqual(error, .fetchTokenError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testTokenFail_missingTokenData() async throws {
        // Given
        let mockKey = MockToken()
        mockKey.mockTokenData = nil
        candidateDetailsManagerViewModel.keychain = mockKey
        
        // When && Then
        do {
            _ = try candidateDetailsManagerViewModel.token()
        } catch let error as CandidateDetailsManagerViewModel.CandidateManagementError {
            XCTAssertEqual(error, .fetchTokenError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_displayCandidateDetails() throws {
        // Given
        let expectedCandidates = [CandidateInformation(id: "vbzfbzvbzh", firstName: "Joe", isFavorite: true, email: "Joe_LastManeOfEarth@gmail.com", lastName: "Washington")]
    }

    func test_candidateUpdater() throws {
       
    }
    func test_updateCandidateInformation() throws {
       
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
            CandidateFetchError.fetchCandidateDetailError
        }
        return candidate
    
}

class MockToken: Keychain {
    var mockTokenData: Data?
    
    enum KeychainError: Error, LocalizedError {
        case getFailed,insertFailed,deleteFailed
        
        var errorDescription: String? {
            switch self {
            case .insertFailed:
                return "Failed to insert item into keychain."
            case .deleteFailed:
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


class MockHTTPpServicee: HTTPService {
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
