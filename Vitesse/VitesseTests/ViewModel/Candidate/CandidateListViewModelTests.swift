// CandidateListViewModelTests.swift
// VitesseTests

import XCTest
@testable import Vitesse

final class CandidateListViewModelTests: XCTestCase {
    var candidateListViewModel: CandidateListViewModel!
    var mockCandidateDataManager: Mocks.MockCandidateDataManager!
    var mocks : Mocks!
    override func setUp() {
        super.setUp()
        mockCandidateDataManager = Mocks.MockCandidateDataManager(httpService: Mocks.MockHTTPServices())
        candidateListViewModel = CandidateListViewModel(retrieveCandidateData: mockCandidateDataManager, keychain:  Mocks.MockKey())
    }
    
    override func tearDown() {
        candidateListViewModel = nil
        mockCandidateDataManager = nil
        super.tearDown()
    }
    
    func testFetchTokenAndRetrieveCandidateListSuccess() async throws {
        // Given
        var mockKey = Mocks.MockKey()
        try  mockKey.add("kfnegjnsdjfgjsdbfgjbdsjfb", forKey: "showList")
        let getToken = try  mockKey.get(forKey: "showList")
        
        //when
      
        //Then
        
    }
    
    func testTokenFail() async throws {
        // Given
        let mockKey =  Mocks.MockKey()
        mockKey.mockTokenData = Data([0xFF, 0xFE]) // Invalid UTF-8
        candidateListViewModel.keychain = mockKey
        
        // When && Then
        do {
            _ = try candidateListViewModel.retrieveToken()
        } catch let error as CandidateManagementError {
            XCTAssertEqual(error, .fetchTokenError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testTokenFail_missingTokenData() async throws {
        // Given
        let mockKey =  Mocks.MockKey()
        mockKey.mockTokenData = nil
        candidateListViewModel.keychain = mockKey
        
        // When && Then
        do {
            _ = try candidateListViewModel.retrieveToken()
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
        
        candidateListViewModel.candidate = expectedCandidates
        
        let mockKey =  Mocks.MockKey()
        let mockTokenString = "fkzerjzehrighze3434"
        mockKey.mockTokenData = mockTokenString.data(using: .utf8)!
        candidateListViewModel.keychain = mockKey
        
        mockCandidateDataManager.mockResponse = HTTPURLResponse(url: URL(string: "http://localhost")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // When
        let response = try await candidateListViewModel.deleteCandidate(at: IndexSet(integer: 0))
        
        // Then
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(candidateListViewModel.candidate.count, 2)
        XCTAssertEqual(candidateListViewModel.candidate.first?.id, "1")
    }
    
    func testShowFavoriteCandidates() async throws {
        // Given
        let mockKey =  Mocks.MockKey()
        let mockTokenString = "fnfkerbjztoken"
        mockKey.mockTokenData = mockTokenString.data(using: .utf8)!
        candidateListViewModel.keychain = mockKey
        
        let expectedCandidate = CandidateInformation(id: "1", firstName: "John", isFavorite: false, email: "john@example.com", lastName: "Doe")
        candidateListViewModel.candidate = [expectedCandidate]
        let id = expectedCandidate.id
        
        //When
        do{
            let showFavoriteCandidates = try await candidateListViewModel.showFavoriteCandidates(selectedCandidateId: id)
            //then
            XCTAssertEqual(showFavoriteCandidates, expectedCandidate)
        }catch let error as CandidateManagementError{
            
            XCTAssertEqual(error, .processCandidateElementsError)
        }
    }
    
    
    func testRemoveCandidate()async throws {
        let mockHTTPServicee = Mocks.MockHTTPServices()
        _ = Mocks.MockCandidateDataManager()
        
        do{
            let removeCandidate =  try await candidateListViewModel.removeCandidate(at: IndexSet())
            XCTAssertNoThrow(removeCandidate)
        }catch{
            XCTFail("erreru")
        }
        
    }
}

// Mock classes
