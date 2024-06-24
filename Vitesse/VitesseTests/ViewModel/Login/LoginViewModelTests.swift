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
    
   
    
    func testInvalidMessage() async throws {
        // Given
        let expectation = XCTestExpectation(description: "onLoginFail is called")
        let authenticationManager = MockAuthenticationManager()
        let keychain = Keychain()
        
        let loginViewModel = LoginViewModel({ expectation.fulfill() }, authenticationManager: authenticationManager, keychain: keychain)
        
        let username = "Paul"
        let password = ""
        
        // Set up mock authentication manager
        authenticationManager.username = username
        authenticationManager.password = password
        authenticationManager.shouldThrowError = true // Simuler une erreur
        
        // When
        do {
            _ = try await loginViewModel.authenticateUserAndProceed()
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
        authenticationManager.username = username
        authenticationManager.password = password
        authenticationManager.shouldThrowError = false
        
        loginViewModel.username = username
        loginViewModel.password = password
        
        do {
            // When
            let authenticationResult = try await loginViewModel.authenticateUserAndProceed()
            
            // Then
            XCTAssertEqual(authenticationResult.isAdmin, true)
            XCTAssertEqual(keychain.storedToken, "valid_token")
            XCTAssertTrue(loginViewModel.isLoggedIn)
            
        } catch let error as Vitesse.LoginViewModel.AuthViewModelFailure {
            XCTAssertEqual(error, .usernameAndPasswordInvalid)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    
    
    func testOnLoginSucceed() async throws {
        // Given
        let expectation = XCTestExpectation(description: "onLogin is called")
        let authenticationManager = MockAuthenticationManager()
        authenticationManager.shouldThrowError = false
        let keychain = Keychain() // Assurez-vous que Keychain est correctement initialisé
        let viewModel = LoginViewModel({ expectation.fulfill() }, authenticationManager: authenticationManager, keychain: keychain)
        
        // When
        do {
           let authenticateUserAndProceed = try await loginViewModel.authenticateUserAndProceed()
            XCTAssertNoThrow(authenticateUserAndProceed)
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
