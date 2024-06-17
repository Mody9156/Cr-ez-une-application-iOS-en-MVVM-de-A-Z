// CandidateListViewModelTests.swift
// VitesseTests

import XCTest
@testable import Vitesse

final class CandidateListViewModelTests: XCTestCase {
    var candidateListViewModel: CandidateListViewModel!
    var mockCandidateDataManager: MockCandidateDataManager!
    
    override func setUp() {
        super.setUp()
        mockCandidateDataManager = MockCandidateDataManager(httpService: MockHTTPServicee())
        candidateListViewModel = CandidateListViewModel(retrieveCandidateData: mockCandidateDataManager, keychain: MockKey())
    }
    
    override func tearDown() {
        candidateListViewModel = nil
        mockCandidateDataManager = nil
        super.tearDown()
    }
    
    func testTokenSuccess() async throws {
        // Given
        let mockTokenString = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFkbWluQHZpdGVzc2UuY29tIiwiaXNBZG1pbiI6dHJ1ZX0.J83TqjxRzmuDuruBChNT8sMg5tfRi5iQ6tUlqJb3M9U"
        let mockTokenData = mockTokenString.data(using: .utf8)!
        let mockKey = MockKey()
        mockKey.mockTokenData = mockTokenData
        candidateListViewModel.keychain = mockKey
        
        // When
        let token = try candidateListViewModel.token()
        
        // Then
        XCTAssertEqual(token, mockTokenString)
    }
    
    func testTokenFail() async throws {
        // Given
        let mockKey = MockKey()
        mockKey.mockTokenData = Data([0xFF, 0xFE]) // Invalid UTF-8
        candidateListViewModel.keychain = mockKey
        
        // When && Then
        do {
            _ = try candidateListViewModel.token()
        } catch let error as CandidateManagementError {
            XCTAssertEqual(error, .fetchTokenError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testTokenFail_missingTokenData() async throws {
        // Given
        let mockKey = MockKey()
        mockKey.mockTokenData = nil
        candidateListViewModel.keychain = mockKey
        
        // When && Then
        do {
            _ = try candidateListViewModel.token()
        } catch let error as CandidateManagementError {
            XCTAssertEqual(error, .fetchTokenError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testDisplayCandidatesList() async throws {
        // Given
        let expectedCandidates = [CandidateInformation(id: "vbzfbzvbzh", firstName: "Joe", isFavorite: true, email: "Joe_LastManeOfEarth@gmail.com", lastName: "Washington")]
        mockCandidateDataManager.mockCandidates = expectedCandidates
        
        // When
        let candidatesList = try await candidateListViewModel.displayCandidatesList()
        
        // Then
        XCTAssertNotNil(candidatesList)
        XCTAssertEqual(candidatesList.count, expectedCandidates.count)
        XCTAssertEqual(candidatesList, expectedCandidates)
    }
    
    func testInvalidDisplayCandidatesList() async throws {
        // Given
        mockCandidateDataManager.mockCandidates = []
        
        // When
        let candidatesList = try await candidateListViewModel.displayCandidatesList()
        
        // Then
        XCTAssertNotNil(candidatesList)
        XCTAssertTrue(candidatesList.isEmpty)
    }
    
    func testDeleteCandidate() async throws {
        // Given
        let expectedCandidates = [
            CandidateInformation(id: "1", firstName: "John", isFavorite: false, email: "john@example.com", lastName: "Doe"),
            CandidateInformation(id: "2", firstName: "Jane", isFavorite: true, email: "jane@example.com", lastName: "Doe")
        ]
        candidateListViewModel.candidats = expectedCandidates
        
        let mockKey = MockKey()
        let mockTokenString = "fkzerjzehrighze3434"
        mockKey.mockTokenData = mockTokenString.data(using: .utf8)!
        candidateListViewModel.keychain = mockKey
        
        mockCandidateDataManager.mockResponse = HTTPURLResponse(url: URL(string: "http://localhost")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // When
        let response = try await candidateListViewModel.deleteCandidate(at: IndexSet(integer: 0))
        
        // Then
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(candidateListViewModel.candidats.count, 2)
        XCTAssertEqual(candidateListViewModel.candidats.first?.id, "1")
    }
    
    //    func testShowFavoriteCandidates() async throws {
    //        // Given
    //        let mockKey = MockKey()
    //        let mockTokenString = "fnfkerbjztoken"
    //        mockKey.mockTokenData = mockTokenString.data(using: .utf8)!
    //        candidateListViewModel.keychain = mockKey
    //
    //        let expectedCandidate = CandidateInformation(id: "1", firstName: "John", isFavorite: false, email: "john@example.com", lastName: "Doe")
    //        candidateListViewModel.candidats = [expectedCandidate]
    //        let id = expectedCandidate.id
    //        //When
    //        do{
    //            let showFavoriteCandidates = try await candidateListViewModel.showFavoriteCandidates(selectedCandidateId: id)
    //            //then
    //            XCTAssertEqual(showFavoriteCandidates, expectedCandidate)
    //        }catch{
    //
    //            XCTFail("Unexpected error: \(error)")
    //        }
    //    }
    
    
    func testRemoveCandidate() throws {
        // Add implementation and assertions
    }
}

// Mock classes

class MockKey: Keychain {
    var mockTokenData: Data?
    
    enum KeychainError: Error, LocalizedError {
        case getFailed
        
        var errorDescription: String? {
            switch self {
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

class MockHTTPServicee: HTTPService {
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
