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
        XCTAssertTrue(loginViewModel.isLoggedIn)
    }

    func testOnLoginSucceed() async throws {
        // Given
        let expectation = XCTestExpectation(description: "onLoginSucceed is called")
        let viewModel = LoginViewModel({ expectation.fulfill() }, authenticationManager: authenticationManager, keychain: keychain)

        // When
        authenticationManager.mockAuthenticationResult = JSONResponseDecodingModel(token: "valid_token", isAdmin: true)
        try await viewModel.authenticateUserAndProceed()

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    func testInvalidPasswordAuthenticateUserAndProceed() async throws {
        // Given
        let username = "admin@vitesse.com"
        let password = ""
        authenticationManager.shouldThrowError = true
        loginViewModel.username = username
        loginViewModel.password = password

        // When & Then
        do {
            let _ = try await loginViewModel.authenticateUserAndProceed()
            XCTFail("Expected an error to be thrown, but no error was thrown.")
        } catch let error as LoginViewModel.AuthViewModelFailure {
            XCTAssertEqual(error, .tokenInvalide)
        } catch {
            XCTFail("Unexpected error type: \(error)")
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
            XCTAssertEqual(error, .tokenInvalide)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}

class MockAuthenticationManager: AuthenticationManager {
    var mockAuthenticationResult: JSONResponseDecodingModel?
    var shouldThrowError = false

    override func authenticate(username: String, password: String) async throws -> JSONResponseDecodingModel {
        if shouldThrowError {
            throw LoginViewModel.AuthViewModelFailure.tokenInvalide
        }
        return mockAuthenticationResult!
    }
}

class MockKeychain: Keychain {
    var storedToken: String?

    override func add(_ token: String, forKey key: String) throws {
        storedToken = token
    }
}
