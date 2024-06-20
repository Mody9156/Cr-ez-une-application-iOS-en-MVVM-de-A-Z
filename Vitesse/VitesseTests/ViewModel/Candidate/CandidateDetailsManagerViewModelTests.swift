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
        candidateDetailsManagerViewModel = CandidateDetailsManagerViewModel(retrieveCandidateData: CandidateDataManager(httpService: MockHTTPpServicesDetails()), keychain: MockToken())
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
            _ = try candidateDetailsManagerViewModel.retrieveToken()
            
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
            _ = try candidateDetailsManagerViewModel.retrieveToken()
        } catch let error as CandidateDetailsManagerViewModel.CandidateManagementError {
            XCTAssertEqual(error, .fetchTokenError)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    
    
    func test_displayCandidateDetails() async throws {
        // Given
        let expectedCandidates = CandidateInformation(id: "vbzfbzvbzh", firstName: "Joe", isFavorite: true, email: "Joe_LastManeOfEarth@gmail.com", lastName: "Washington")
        
        let mockCandidatesDataManager = MockCandidatesDataManager(httpService: MockHTTPpServicesDetails())
        
        mockCandidatesDataManager.mockCandidates = expectedCandidates
        candidateDetailsManagerViewModel.retrieveCandidateData = mockCandidatesDataManager
        candidateDetailsManagerViewModel.selectedCandidateId = expectedCandidates.id
        
        do{
            //When
            let displayCandidateDetails = try await   candidateDetailsManagerViewModel.displayCandidateDetails()
            //then
            XCTAssertNotNil(displayCandidateDetails)
            XCTAssertEqual(displayCandidateDetails.email, expectedCandidates.email)
            XCTAssertEqual(displayCandidateDetails, expectedCandidates)
        }catch let error as CandidateDetailsManagerViewModel.CandidateManagementError{
            XCTAssertEqual(error, .displayCandidateDetailsError)
        }
        
    }
    
    func testSelectedCandidateId()async throws{
        
        do{
            let displayCandidateDetails =  try await candidateDetailsManagerViewModel.displayCandidateDetails()
            XCTAssertNil(displayCandidateDetails.id)
        }catch let error as CandidateDetailsManagerViewModel.CandidateManagementError{
            XCTAssertEqual(error, .displayCandidateDetailsError)
        }
    }
    
    func test_candidateUpdater()async throws {
        // Given
        let expectedCandidates = CandidateInformation(
            phone: "123-456-7890",
            note: "Mise à jour réussie",
            id: "12345", firstName: "John",
            linkedinURL: "https://www.linkedin.com/in/johndoe",
            isFavorite: true,
            email: "john.doe@example.com",
            lastName: "Doe"
        )
        let mockCandidatesDataManager = MockCandidatesDataManager(httpService: MockHTTPpServicesDetails())
        mockCandidatesDataManager.mockCandidates = expectedCandidates
        candidateDetailsManagerViewModel.retrieveCandidateData = mockCandidatesDataManager
        candidateDetailsManagerViewModel.selectedCandidateId = expectedCandidates.id
        
        do{
            //When
            let displayCandidateDetails = try await   candidateDetailsManagerViewModel.candidateUpdater(
                phone: "123-456-7890",
                note: "Excellent candidat avec une grande expérience.",
                firstName: "John",
                linkedinURL: "https://www.linkedin.com/in/johndoe",
                isFavorite: true,
                email: "john.doe@example.com",
                lastName: "Doe",
                id: "12345"
            )
            //then
            XCTAssertNotNil(displayCandidateDetails)
            XCTAssertEqual(displayCandidateDetails.email, expectedCandidates.email)
            XCTAssertEqual(displayCandidateDetails.email,"john.doe@example.com")
            XCTAssertEqual(displayCandidateDetails, expectedCandidates)
        }catch let error as CandidateDetailsManagerViewModel.CandidateManagementError{
            XCTAssertEqual(error, .candidateUpdaterError)
        }catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_updateCandidate() async throws {
        // Given
        let mockCandidatesDataManager = MockCandidatesDataManager(httpService: MockHTTPService())
        candidateDetailsManagerViewModel.retrieveCandidateData = mockCandidatesDataManager
        
        // Simuler une erreur
        mockCandidatesDataManager.shouldThrowError = true
        mockCandidatesDataManager.errorToThrow = .fetchCandidateDetailError
        
        do{
            // When
            _ = try await candidateDetailsManagerViewModel.candidateUpdater(
                phone: "123-456-7890",
                note: "Mise à jour réussie",
                firstName: "John",
                linkedinURL: "https://www.linkedin.com/in/johndoe",
                isFavorite: true,
                email: "john.doe@example.com",
                lastName: "Doe",
                id: "12345"
            )
            XCTFail("Expected to throw an error, but did not throw")            //then
            
        }catch let error as CandidateDetailsManagerViewModel.CandidateManagementError{
            XCTAssertEqual(error, .candidateUpdaterError)
        }catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    
    func testUpdateCandidateInformation()async throws{
        // Given
        let initialCandidate = CandidateInformation(
            phone: "123-456-7890",
            note: "Initial Note",
            id: "12345", firstName: "John",
            linkedinURL: "https://www.linkedin.com/in/johndoe",
            isFavorite: true,
            email: "john.doe@example.com",
            lastName: "Doe"
        )
        
        let updatedCandidate = CandidateInformation(
            phone: "987-654-3210",
            note: "Updated Note",
            id: "12345", firstName: "John Updated",
            linkedinURL: "https://www.linkedin.com/in/johndoe-updated",
            isFavorite: false,
            email: "john.updated@example.com",
            lastName: "Doe Updated"
        )
        
        let viewModel = CandidateDetailsManagerViewModel(retrieveCandidateData: MockCandidatesDataManager(httpService: MockHTTPpServicesDetails()), keychain: MockToken())
        viewModel.candidats = [initialCandidate]
        
        viewModel.updateCandidateInformation(with: updatedCandidate)
        
        //Then
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.candidats.count,1 )
        XCTAssertEqual(viewModel.candidats.first?.phone, updatedCandidate.phone)
        XCTAssertEqual(viewModel.candidats.first?.note, updatedCandidate.note)
        XCTAssertEqual(viewModel.candidats.first?.firstName, updatedCandidate.firstName)
        XCTAssertEqual(viewModel.candidats.first?.linkedinURL, updatedCandidate.linkedinURL)
        XCTAssertEqual(viewModel.candidats.first?.isFavorite, updatedCandidate.isFavorite)
        XCTAssertEqual(viewModel.candidats.first?.email, updatedCandidate.email)
        XCTAssertEqual(viewModel.candidats.first?.lastName, updatedCandidate.lastName)
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
    
    class MockToken: Keychain {
        var mockTokenData: Data?
        
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
    
    
    class MockHTTPpServicesDetails: HTTPService {
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
    
}
