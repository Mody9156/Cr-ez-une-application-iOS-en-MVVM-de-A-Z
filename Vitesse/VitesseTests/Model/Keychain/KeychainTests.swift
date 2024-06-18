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
          let key = "example_1"
          let data = "example_of_token"
          
          // Mock a scenario where SecItemAdd will fail by using a very long key
          let longKey = String(repeating: "A", count: 1000)
          
          // When
          do {
              try keychain.add(data, forKey: longKey)
              
              // If no error is thrown, the test should fail
          
          } catch let error as Keychain.KeychainError {
              // Then
              XCTAssertEqual(error, .insertFailed, "Expected to receive an insertFailed error.")
          } catch {
              // If any other error is thrown, the test should fail
              XCTFail("Unexpected error: \(error)")
          }
      }

    func testget() throws {
      
    }
    func testdelete() throws {
      
    }

}
