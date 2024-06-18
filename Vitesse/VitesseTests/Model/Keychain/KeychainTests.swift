//
//  KeychainTests.swift
//  VitesseTests
//
//  Created by KEITA on 18/06/2024.
//

import XCTest
@testable import Vitesse
final class KeychainTests: XCTestCase {

    func testkeychain() throws {
        //Given
       let keychain = Keychain()
        //When
        do{
       try keychain.add("exemple_of_token", forKey: "exemple_1")
         
        //Then
            XCTAssertNoThrow( try keychain.add("exemple_of_token", forKey: "exemple_1"))
            
        }catch  {
            XCTFail("Unexpected error: \(error)")        }
       
    }
//    func testInvalid_keychain() throws {
//        //Given
//       let keychain = Keychain()
//        //When
//        do{
//         let add =  try keychain.add("exemple_of_token", forKey: "")
//         let get =  try keychain.get(forKey: "exemple_1")
//            guard let encodingToken = String(data: get, encoding: .utf8) else {
//                throw CandidateManagementError.fetchTokenError
//            }
//
//            XCTAsserttrue(encodingToken.isEmpty)
//        }catch let error as Keychain.KeychainError {
//            XCTAssertEqual(error, .insertFailed,"Failed to insert item into keychain.")
//        }
//
//    }
    func testPerformanceExample() throws {
      
    }

}
