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
        candidateDetailsManagerViewModel = CandidateDetailsManagerViewModel(retrieveCandidateData: CandidateDataManager(httpService: Mocks.MockHTTPServices()), keychain: Mocks.MockKeychain())
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
        let mockKey = Mocks.MockKeychain()
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
        let mockKey = Mocks.MockKeychain()
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
        
        let mockCandidatesDataManager = Mocks.MockCandidateDataManager(httpService: Mocks.MockHTTPServices())
        
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
        let mockCandidatesDataManager = Mocks.MockCandidateDataManager(httpService: Mocks.MockHTTPServices())
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
        let mockCandidatesDataManager = Mocks.MockCandidateDataManager(httpService: MockHTTPService())
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
        
        let viewModel = CandidateDetailsManagerViewModel(retrieveCandidateData: Mocks.MockCandidateDataManager(httpService: Mocks.MockHTTPServices()), keychain: Mocks.MockKeychain())
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
}
    
