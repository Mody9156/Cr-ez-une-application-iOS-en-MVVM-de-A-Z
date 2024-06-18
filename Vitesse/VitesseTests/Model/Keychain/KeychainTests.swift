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
      let add =  try keychain.add("exemple_of_token", forKey: "exemple_1")
         
        //Then
            XCTAssertNoThrow( try keychain.add("exemple_of_token", forKey: "exemple_1"))
        }catch  {
            XCTFail("Unexpected error: \(error)")        }
       
    }
    func testAddItemFailure() throws {
          // Given
          let keychain = Keychain()
         
          
          // Mock a scenario where SecItemAdd will fail by using a very long key
          
          // When
          do {
              try keychain.add("", forKey: "")
             XCTAssertNoThrow(try keychain.add("", forKey: ""))
          
          } catch let error as Keychain.KeychainError {
              // Then
              XCTAssertEqual(error, .insertFailed, "Expected to receive an insertFailed error.")
          } catch {
              // If any other error is thrown, the test should fail
              XCTFail("Unexpected error: \(error)")
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
    func testInvalidget() throws {
        let keychain = Keychain()
     
        
        do{
            try keychain.get(forKey: "exemple_3")
            XCTAssertNoThrow(try keychain.get(forKey: "exemple_3"))
        }catch let error as Keychain.KeychainError{
            XCTAssertEqual(error, .getFailed)
        }
      
    }
    func testdelete() throws {
      
    }

}
