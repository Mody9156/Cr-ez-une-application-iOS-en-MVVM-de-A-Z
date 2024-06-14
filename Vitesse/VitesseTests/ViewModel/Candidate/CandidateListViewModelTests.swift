//
//  CandidateListViewModelTests.swift
//  VitesseTests
//
//  Created by KEITA on 12/06/2024.
//

import XCTest
@testable import Vitesse

final class CandidateListViewModelTests: XCTestCase {
    var candidateListViewModel : CandidateListViewModel!
    override func setUp()  {
        candidateListViewModel = CandidateListViewModel(retrieveCandidateData: MockCandidateDataManager(),keychain: MockKey())
        super.setUp()
    }
    
    override func tearDown()  {
        candidateListViewModel = nil
        super.tearDown()
    }
    
    func testTokenSuccess() async throws {
        // Given
        let mockTokenString = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImV4ZW1wbGUyMjMxMkBnbWFpbC5jb20iLCJpc0FkbWluIjpmYWxzZX0.t3ec7oA3gEQJT1gh_qahIPzawLN4o_bTkAsE0iHg3rg"
        let mockTokenData = mockTokenString.data(using: .utf8)!
        
        let mockKey = MockKey()
        mockKey.mockTokenData = mockTokenData
        
        
        // When
        do {
            let token = try candidateListViewModel.token()
            
            // Then
            XCTAssertEqual(token, mockTokenString)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testTokenFail() async throws {
        // Given
        let mockTokenString = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImV4ZW1wbGUyMjMxMkBnbWFpbC5jb20iLCJpc0FkbWluIjpmYWxzZX0.t3ec7oA3gEQJT1gh_qahIPzawLN4o_bTkAsE0iHg3rg"
        let mockTokenData = mockTokenString.data(using: .utf8)!
        
        let mockKey = MockKey()
        mockKey.mockTokenData = mockTokenData
        
        
        // When
        do {
            let token = try candidateListViewModel.token()
            
            // Then
            XCTAssertEqual(token, mockTokenString)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    
    
    func testDisplayCandidatesList() async throws {
        //Given
        let expectedCandidates = [CandidateInformation(id: "vbzfbzvbzh", firstName: "Joe", isFavorite: true, email: "Joe_LastManeOfEarth@gmail.com", lastName: "Washington")]
        (candidateListViewModel.retrieveCandidateData as! MockCandidateDataManager).mockCandidates = expectedCandidates
        
        //When
        let candidatesList =  try await candidateListViewModel.displayCandidatesList()
        
        //Then
        XCTAssertNotNil(candidatesList)
        XCTAssertEqual(candidatesList.count, expectedCandidates.count)
        XCTAssertEqual(candidatesList, expectedCandidates)
        
    }
    
    
    func testInvalidDisplayCandidatesList() async throws {
        //Given
        
        (candidateListViewModel.retrieveCandidateData as! MockCandidateDataManager).mockCandidates = []
        
        //When
        let candidatesList =  try await candidateListViewModel.displayCandidatesList()
        
        //Then
        XCTAssertNotNil(candidatesList)
        XCTAssertTrue(candidatesList.isEmpty)
    }
    
    func testDisplayCandidatesList_throw() async throws {
        
        
        //When && Then
        do{
            let candidatesList =  try await candidateListViewModel.displayCandidatesList()
        }catch let error as CandidateManagementError{
            XCTAssertEqual(error, .displayCandidatesListError)
            
        }
        
        
        
    }
    
    func testDeleteCandidate() throws {
        
    }
    func testShowFavoriteCandidates() throws {
        
    }
    func testRemoveCandidate() throws {
        
    }
    
}


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




class MockCandidates{
    static var candidate_url: String?
    
    static func createURLRequest(url: String, method: String, token: String, id: String) throws -> URLRequest {
        candidate_url = url
        guard let validURL = URL(string: url) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: validURL)
        request.httpMethod = method
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}


class MockCandidateDataManager: CandidateDataManager {
    var mockCandidates: [CandidateInformation] = []
    
    override func fetchCandidateData(request: URLRequest) async throws -> [CandidateInformation] {
        return mockCandidates
    }
}

class MockCandidatess {
    static  var lastCalledURL: String?
    static var lastCalledMethod: String?
    static var lastCalledToken: String?
    static var shouldThrowError: Bool = false
    
    static func loadCandidatesFromURL(url: String, method: String, token: String) throws -> URLRequest {
        lastCalledURL = url
        lastCalledMethod = method
        lastCalledToken = token
        
        if shouldThrowError {
            throw URLError(.badURL)
        }
        
        guard let validURL = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: validURL)
        request.httpMethod = method
        let authHeader = "Bearer \(token)"
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
