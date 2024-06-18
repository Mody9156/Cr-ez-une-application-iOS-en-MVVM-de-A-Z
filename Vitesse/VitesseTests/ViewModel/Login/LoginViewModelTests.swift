//
//  LoginViewModelTests.swift
//  VitesseTests
//
//  Created by KEITA on 12/06/2024.
//

import XCTest
@testable import Vitesse

final class LoginViewModelTests: XCTestCase {
    var loginViewModel: LoginViewModel!
    var keychain: MockKeychain!
    var authenticationManager: MockAuthenticationManager!
    
    override func setUp() {
        super.setUp()
        authenticationManager = MockAuthenticationManager()
        keychain = MockKeychain()
        loginViewModel = LoginViewModel({ }, authenticationManager: authenticationManager, keychain: keychain)
    }
    
    override func tearDown() {
        loginViewModel = nil
        keychain = nil
        authenticationManager = nil
        super.tearDown()
    }
    
    func testTextFieldValidatorPassword(){
        //Given
        let password = "simple_test"
        
        //When
        let textFieldValidatorPassword = loginViewModel.textFieldValidatorPassword(password)
        
        //Then
        XCTAssertTrue(textFieldValidatorPassword)
    }
    
    func testTextFieldValidatorEmail(){
        //Given
        let email = "exemplede_mail@gmai.com"
        //When
        let textFieldValidatorEmail = loginViewModel.textFieldValidatorEmail(email)
        //Then
        XCTAssertTrue(textFieldValidatorEmail)
        
    }
    
    func testFailTextFieldValidatorEmail(){
        //Given
        let email = "exemplede"
        let email_1 = "abcdefghijABCDEFGHIJklmnopqrstKLMNOPQRSTuvwxyzUVWXYZabcdefghijABCDEFGHIJklmnopqrstKLMNOPQRSTuvwxyzUVWX@example.com"
        //When
        let textFieldValidatorEmail = loginViewModel.textFieldValidatorEmail(email)
        let textFieldValidatorEmail_1 = loginViewModel.textFieldValidatorEmail(email_1)
        //Then
        XCTAssertFalse(textFieldValidatorEmail)
        XCTAssertTrue(email_1.count > 100  )
        
    }
    
    func testMessage() async throws {
        // Given
        let expectation = XCTestExpectation(description: "onLoginFail is called")
        let authenticationManager = MockAuthenticationManager()
        let keychain = Keychain() // Assurez-vous que Keychain est correctement initialisé
        let loginViewModel = LoginViewModel({ expectation.fulfill() }, authenticationManager: authenticationManager, keychain: keychain)

        // Configuration des valeurs d'authentification pour le test
        let username = "Paul"
        let password = ""

        // Set up mock authentication manager
        authenticationManager.username = username
        authenticationManager.password = password
        authenticationManager.shouldThrowError = true // Simuler une erreur

        // When
        do {
            try await loginViewModel.authenticateUserAndProceed()
            XCTFail("Expected an error to be thrown, but no error was thrown.")
            // Then
            wait(for: [expectation], timeout: 1)
           
        } catch let error as LoginViewModel.AuthViewModelFailure {
            XCTAssertEqual(error, .usernameAndPasswordInvalid)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }

       
    }
    func testAuthenticateUserAndProceed() async throws {
        // Given
        let username = "admin@vitesse.com"
        let password = "test123"
        authenticationManager.mockAuthenticationResult = JSONResponseDecodingModel(token: "valid_token", isAdmin: true)
        loginViewModel.username = username
        loginViewModel.password = password
        
        // When
        let authenticationResult = try await loginViewModel.authenticateUserAndProceed()
        
        // Then
        XCTAssertEqual(authenticationResult.isAdmin, true)
        XCTAssertEqual(keychain.storedToken, "valid_token")
        XCTAssertTrue(loginViewModel.isLoggedIn)  // Vérifier que l'utilisateur est connecté
    }
//    func testInvalidAuthenticateUserAndProceed() async throws {
//        // Given
//        let expectation = XCTestExpectation(description: "onLoginFail is called")
//        let authenticationManager = MockAuthenticationManager()
//        let keychain = Keychain() // Assurez-vous que Keychain est correctement initialisé
//        let loginViewModel = LoginViewModel({ expectation.fulfill() }, authenticationManager: authenticationManager, keychain: keychain)
//
//        let username = "admin@vitesse.com"
//        let password = "test123"
//        // Set up mock authentication manager
//          authenticationManager.username = username
//          authenticationManager.password = password
//        authenticationManager.shouldThrowError = true // Simuler une erreur de token invalide
//
//        // When
//          do {
//              try await loginViewModel.authenticateUserAndProceed()
//            
//              // Then
//              XCTFail("Expected an error to be thrown, but no error was thrown.")
//              wait(for: [expectation], timeout: 1)
//          } catch let error as LoginViewModel.AuthViewModelFailure {
//              XCTAssertEqual(error, .tokenInvalid)
//          } catch {
//              XCTFail("Unexpected error type: \(error)")
//          }
//
//          // Then
//          XCTAssertFalse(loginViewModel.isLoggedIn)
//    }
//    
    func testOnLoginSucceed() async throws {
        // Given
          let expectation = XCTestExpectation(description: "onLoginFail is called")
          let authenticationManager = MockAuthenticationManager()
          authenticationManager.shouldThrowError = false
          let keychain = Keychain() // Assurez-vous que Keychain est correctement initialisé
          let viewModel = LoginViewModel({ expectation.fulfill() }, authenticationManager: authenticationManager, keychain: keychain)
          
          // When
          do {
              try await loginViewModel.authenticateUserAndProceed()
          } catch let error as LoginViewModel.AuthViewModelFailure {
              XCTAssertEqual(error, .usernameAndPasswordInvalid)
              expectation.fulfill()
          }

          // Then
          wait(for: [expectation], timeout: 1.0)
          XCTAssertFalse(viewModel.isLoggedIn)
    }
    
    func testInvalidPasswordAuthenticateUserAndProceed() async throws {
        // Given
        let username = "adm@vitesse.com"
        let password = ""
        authenticationManager.shouldThrowError = true
        loginViewModel.username = username
        loginViewModel.password = password
        
        // When & Then
        do {
            let _ = try await loginViewModel.authenticateUserAndProceed()
            XCTFail("Expected an error to be thrown, but no error was thrown.")
        } catch let error as LoginViewModel.AuthViewModelFailure {
            XCTAssertEqual(error, .usernameAndPasswordInvalid)
        }
    }
    
    func testInvalidUsernameAuthenticateUserAndProceed() async throws {
        // Given
        let username = ""
        let password = "test123"
        authenticationManager.shouldThrowError = true
        loginViewModel.username = username
        loginViewModel.password = password
        
        // When & Then
        do {
            let _ = try await loginViewModel.authenticateUserAndProceed()
            XCTFail("Expected an error to be thrown, but no error was thrown.")
        } catch let error as LoginViewModel.AuthViewModelFailure {
            XCTAssertEqual(error, .usernameAndPasswordInvalid)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}

class MockAuthenticationManager: AuthenticationManager {
    var mockAuthenticationResult: JSONResponseDecodingModel?
    var shouldThrowError = false
    var username : String = ""
    var password : String = ""
    override func authenticate(username: String, password: String) async throws -> JSONResponseDecodingModel {
        if shouldThrowError {
            throw LoginViewModel.AuthViewModelFailure.tokenInvalid
        }
        guard let result = mockAuthenticationResult else {
                    throw LoginViewModel.AuthViewModelFailure.tokenInvalid
                }
                return result
    }
}

class MockKeychain: Keychain {
    var storedToken: String?
    
    override func add(_ token: String, forKey key: String) throws {
        storedToken = token
    }
}
