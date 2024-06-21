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
    
    func testFetchTokenAndRetrieveCandidateListSuccess() async throws {
        // Given
        var mockKey = Mocks.MockKeychain()
        
        try mockKey.add("9tIiwiaXNBZG1pbiI6dHJ1ZX0.J83TqjxRzmuDuruBChNT8Mg5tfRi5iQ6tUlqJb3M9U", forKey: "showList")
        
        do{
            //when
            let getToken = try mockKey.get(forKey: "showList")
            
            guard String(data: getToken, encoding: .utf8) != nil else {
                XCTFail("Failed to encode token")
                return
            }
            
            let retrieveToken = try candidateListViewModel.retrieveToken()
            //Then
            XCTAssertNoThrow(retrieveToken)
            
        }catch {
            XCTFail("Failed to get item from keychain: \(error.localizedDescription)")
            
        }
        
    }
    
    func testInvalidFetchTokenAndRetrieveCandidateListSuccess() async throws {
        // Given
        let mockKey =  Mocks.MockKeychain()
        //crée un objet Data contenant deux octets avec les valeurs hexadécimales 0xFF et 0xFE,
       mockKey.mockTokenData = Data([0xFF, 0xFE])
        
        // Invalid UTF-8
        candidateListViewModel.keychain = mockKey
        
        // When && Then
        do {
            let MockData = try candidateListViewModel.retrieveToken()
           
        } catch let error as CandidateManagementError {
            XCTAssertEqual(error, .fetchTokenError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testTokenFail_missingTokenData() async throws {
        // Given
        let mockKey =  Mocks.MockKeychain()
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
        mockCandidateDataManager.mockCandidates_array = expectedCandidates
        
        // When
        let candidatesList = try await candidateListViewModel.displayCandidatesList()
        
        // Then
        XCTAssertNotNil(candidatesList)
        XCTAssertEqual(candidatesList.count, expectedCandidates.count)
        XCTAssertEqual(candidatesList, expectedCandidates)
    }
    
    func testInvalidDisplayCandidatesList() async throws {
        // Given
        mockCandidateDataManager.mockCandidates_array = []
        
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
