//
//  KeychainTests.swift
//  VitesseTests
//
//  Created by KEITA on 18/06/2024.
//

import XCTest
@testable import Vitesse
final class KeychainTests: XCTestCase {

    func testKeychain() throws {
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
    func testAddItemFailure() throws {
          // Given
          let keychain = Keychain()
         
          // When
          do {
              try keychain.add("gger", forKey: "k")
              XCTFail("Expected to receive a deleteFailed error.")

          } catch let error as Keychain.KeychainError {
              // Then
              XCTAssertEqual(error, .insertFailed)
          } 
      }

    func testget() throws {
        let keychain = Keychain()
        
        
        do{
            try keychain.get(forKey: "exemple_1")
            XCTAssertNoThrow(try keychain.get(forKey: "exemple_1"))
        }catch let error as Keychain.KeychainError{
            XCTAssertEqual(error, .getFailed)
        }
      
    }
    func testInvalidGet() throws {
        let keychain = Keychain()
        
        do{
            try keychain.get(forKey: "exemple_3")
            XCTAssertNoThrow(try keychain.get(forKey: "exemple_3"))
        }catch let error as Keychain.KeychainError{
            XCTAssertEqual(error, .getFailed)
        }
      
    }
    
    func test_delete() throws {
        let keychain = Keychain()
        let token = String(repeating: "Mffzef", count: 15)
        
        do{
            try keychain.add(token, forKey: "exemple_20")
             try keychain.delete(forKey: "exemple_50")
            XCTFail("Expected to receive a deleteFailed error.")

        }catch let error as Keychain.KeychainError{
            XCTAssertEqual(error, .deleteFailed)
        }
    }
    
    func test_Invalid_delete() throws {
        let keychain = Keychain()
        
        do{
             try keychain.delete(forKey: "exemple_50")
            XCTFail("Expected to receive a deleteFailed error.")

        }catch let error as Keychain.KeychainError{
            XCTAssertEqual(error, .deleteFailed)
        }
    }

}
