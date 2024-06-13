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
    var mockKey : MockKey!

    override func setUp()  {
        candidateListViewModel = CandidateListViewModel(retrieveCandidateData: CandidateDataManager())
        mockKey = MockKey()

        super.setUp()
    }

    override func tearDown()  {
        candidateListViewModel = nil
        mockKey = nil

      super.tearDown()
    }

    func testToken() async throws {
        //Given
        
        do{
            //When
            let token = try candidateListViewModel.token()
                
                //Then
            XCTAssertNotNil(token)
            
        }catch let error as CandidateListViewModel.CandidateManagementError{
            XCTAssertEqual(error, .fetchTokenError)
        }
    }
  
   
    func testDisplayCandidatesList() async throws {
        //Given
        let DisplayCandidatesList = try await candidateListViewModel.displayCandidatesList()
        //When
        
        //Then
        XCTAssertNotNil(DisplayCandidatesList)
    }
    func testDeleteCandidate() throws {
       
    }
    func testShowFavoriteCandidates() throws {
       
    }
    func testRemoveCandidate() throws {
        
    }

}



class MockKey: Keychain {
    var stubbedToken: String?
    var stubbedkey: Data?
  
       override func get(forKey key: String) throws -> Data {
           guard let token = stubbedkey else {
               throw NSError(domain: "", code: 0, userInfo: nil)
           }
           return token
       }
}

class MockArray: CandidateInformation {
    
}
