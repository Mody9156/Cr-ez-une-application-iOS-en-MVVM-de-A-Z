// CandidateListViewModelTests.swift
// VitesseTests

import XCTest
@testable import Vitesse

final class CandidateListViewModelTests: XCTestCase {
    var candidateListViewModel: CandidateListViewModel!
    var mockCandidateDataManager: Mocks.MockCandidateDataManager!
    
    override func setUp() {
        super.setUp()
        mockCandidateDataManager = Mocks.MockCandidateDataManager(httpService: Mocks.MockHTTPServices())
        candidateListViewModel = CandidateListViewModel(retrieveCandidateData: mockCandidateDataManager, keychain:  Mocks.MockKeychain())
    }
    
    override func tearDown() {
        candidateListViewModel = nil
        mockCandidateDataManager = nil
        super.tearDown()
    }
    
    
    
    func testDisplayCandidatesList() async throws {
        // Given
        let expectedCandidates = [CandidateInformation(id: "vbzfbzvbzh", firstName: "Joe", isFavorite: true, email: "Joe_LastManeOfEarth@gmail.com", lastName: "Washington")]
        mockCandidateDataManager.mockCandidates_array = expectedCandidates
        do{
            // When
            let candidatesList = try await candidateListViewModel.displayCandidatesList()
            // Then
            XCTAssertNotNil(candidatesList)
            XCTAssertEqual(candidatesList.count, expectedCandidates.count)
            XCTAssertEqual(candidatesList, expectedCandidates)
            
        }catch let error as CandidateManagementError{
            XCTAssertEqual(error, .displayCandidatesListError)
        }
        
    }
    
    func testInvalidDisplayCandidatesList() async throws {
        // Given
        mockCandidateDataManager.mockCandidates_array = []
        mockCandidateDataManager.shouldThrowError = true
        do{
            // When
            let candidatesList = try await candidateListViewModel.displayCandidatesList()
            
            // Then
            XCTAssertNotNil(candidatesList)
            XCTAssertTrue(candidatesList.isEmpty)
        }catch let error as CandidateManagementError{
            XCTAssertEqual(error,.displayCandidatesListError)
        }catch{
            XCTFail("Unexpected error: \(error)")
        }
        
        
    }
    
    func testDeleteCandidate() async throws {
        // Given
        let expectedCandidates = [
            
            CandidateInformation(id: "1", firstName: "John", isFavorite: false, email: "john@example.com", lastName: "Doe"),
            CandidateInformation(id: "2", firstName: "Jane", isFavorite: true, email: "jane@example.com", lastName: "Doe")
        ]
        
        candidateListViewModel.candidate = expectedCandidates
        
        let mockKey =  Mocks.MockKeychain()
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
        let mockKey =  Mocks.MockKeychain()
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
    
}
