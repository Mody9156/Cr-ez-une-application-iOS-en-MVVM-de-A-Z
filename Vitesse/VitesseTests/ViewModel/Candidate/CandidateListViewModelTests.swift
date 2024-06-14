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
    var mockCandidateDataManager: MockCandidateDataManager!
    
    
    override func setUp()  {
        candidateListViewModel = CandidateListViewModel(retrieveCandidateData: mockCandidateDataManager,keychain: MockKey())
        mockCandidateDataManager = MockCandidateDataManager()
        
        super.setUp()
    }
    
    override func tearDown()  {
        candidateListViewModel = nil
        mockCandidateDataManager = nil
        super.tearDown()
    }
    
    func testTokenSuccess() async throws {
        // Given
        let mockTokenString = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImV4ZW1wbGUyMjMxMkBnbWFpbC5jb20iLCJpc0FkbWluIjpmYWxzZX0.t3ec7oA3gEQJT1gh_qahIPzawLN4o_bTkAsE0iHg3rg"
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
        mockKey.mockTokenData = Data([0xFF,0xFE]) //Invalid UTF-8
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
    
    
    
    func testDeleteCandidate() async throws {
        //Given
        let expectedCandidates = [
            CandidateInformation(id: "1", firstName: "John", isFavorite: false, email: "john@example.com", lastName: "Doe"),
            CandidateInformation(id: "2", firstName: "Jane", isFavorite: true, email: "jane@example.com", lastName: "Doe")
        ]
        
        candidateListViewModel.candidats = expectedCandidates
        
        let mockKey = MockKey()
        let mockTokenData = "fkzerjzehrighze3434"
        mockKey.mockTokenData = mockTokenData.data(using: .utf8)!
        
        let mockCandidateDataManager = candidateListViewModel.retrieveCandidateData as! MockCandidatesDataManager
        
        mockCandidateDataManager.mockResponse = HTTPURLResponse(url: URL(string:""), statusCode: <#T##Int#>, httpVersion: <#T##String?#>, headerFields: <#T##[String : String]?#>)
        
        
        
        
        //When
        let response = try await candidateListViewModel.deleteCandidate(at: IndexSet(integer: 0))
        
        //Then
        
        
    }
    func testShowFavoriteCandidates() throws {
        
    }
    func testRemoveCandidate() throws {
        
    }
    
}


//Mock

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
    
    func deleteCandidate(withId id: String) async throws {
        mockCandidates.removeAll { $0.id == id }
    }
    
    func fetchFavoriteCandidates() async throws -> [CandidateInformation] {
        return mockCandidates.filter { $0.isFavorite }
    }
    
    func removeCandidate(withId id: String) async throws {
        mockCandidates.removeAll { $0.id == id }
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


class MockCandidatesDataManager: CandidateDataManager {
    
    var mockCandidates: [CandidateInformation] = []
    var mockCandidate: CandidateInformation?
    var mockResponse: HTTPURLResponse?
    var shouldThrowError: Bool = false
    var errorToThrow: CandidateFetchError?
    
    override init(httpService: HTTPService = URLSessionHTTPClient()) {
        super.init(httpService: httpService)
    }
    
    override func fetchCandidateData(request: URLRequest) async throws -> [CandidateInformation] {
        if shouldThrowError {
            throw errorToThrow ?? CandidateFetchError.fetchCandidateDataError
        }
        guard let response = mockResponse, response.statusCode == 200 else {
            throw CandidateFetchError.httpResponseInvalid(statusCode: mockResponse?.statusCode ?? 500)
        }
        return mockCandidates
    }
    
    override func fetchCandidateDetail(request: URLRequest) async throws -> CandidateInformation {
        if shouldThrowError {
            throw errorToThrow ?? CandidateFetchError.fetchCandidateDetailError
        }
        guard let response = mockResponse, response.statusCode == 200 else {
            throw CandidateFetchError.httpResponseInvalid(statusCode: mockResponse?.statusCode ?? 500)
        }
        guard let candidate = mockCandidate else {
            throw CandidateFetchError.fetchCandidateDetailError
        }
        return candidate
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
    
    override func fetchCandidateInformation(token: String, id: String, phone: String?, note: String?, firstName: String, linkedinURL: String?, isFavorite: Bool, email: String, lastName: String, request: URLRequest) async throws -> CandidateInformation {
        if shouldThrowError {
            throw errorToThrow ?? CandidateFetchError.fetchCandidateInformationError
        }
        guard let candidate = mockCandidate else {
            throw CandidateFetchError.fetchCandidateInformationError
        }
        return candidate
    }
}
