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
        candidateListViewModel = CandidateListViewModel(retrieveCandidateData: CandidateDataManager())

        super.setUp()
    }

    override func tearDown()  {
        candidateListViewModel = nil

      super.tearDown()
    }

    func testTokenSuccess() async throws {
        // Given
               let mockTokenString = "mockTokenString"
               let mockTokenData = mockTokenString.data(using: .utf8)!
               
               let mockKey = MockKey()
                mockKey.mockTokenData = mockTokenData
               
               let authenticationManager = AuthenticationManager(keychain: mockKeychain)
               
               // When
               do {
                   let token = try authenticationManager.token()
                   
                   // Then
                   XCTAssertEqual(token, mockTokenString)
               } catch {
                   XCTFail("Unexpected error: \(error)")
               }
    }
    
    func token_failure() async throws {
 
    }
  
   
    func testDisplayCandidatesList() async throws {
//        //Given
//        let DisplayCandidatesList = try await candidateListViewModel.displayCandidatesList()
//        //When
//        
//        //Then
//        XCTAssertNotNil(DisplayCandidatesList)
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
       var shouldThrowError = false
       
    override func get(forKey key: String) throws -> Data {
           if shouldThrowError {
               throw CandidateManagementError.fetchTokenError
           }
           guard let tokenData = mockTokenData else {
               throw CandidateManagementError.fetchTokenError
           }
           return tokenData
       }
   }
