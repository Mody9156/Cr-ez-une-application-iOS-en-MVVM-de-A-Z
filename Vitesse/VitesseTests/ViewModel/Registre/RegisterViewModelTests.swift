import XCTest
@testable import Vitesse

final class RegisterViewModelTests: XCTestCase {
    var registerViewModel: RegisterViewModel!
    var registrationRequestBuilder: MockRegistrationRequestBuilder!
    var loginViewModel: MockLoginViewModel!

    override func setUp() {
        super.setUp()
        registrationRequestBuilder = MockRegistrationRequestBuilder()
        loginViewModel = MockLoginViewModel({})
        registerViewModel = RegisterViewModel(registrationRequestBuilder: registrationRequestBuilder, loginViewModel: loginViewModel)
    }

    override func tearDown() {
        registerViewModel = nil
        registrationRequestBuilder = nil
        loginViewModel = nil
        super.tearDown()
    }

    func testHandleRegistrationViewModel() async throws {
        // Given
        let email = "test@example.com"
        let password = "securePassword123"
        let firstName = "John"
        let lastName = "Doe"
        registerViewModel.email = email
        registerViewModel.password = password
        registerViewModel.firstName = firstName
        registerViewModel.lastName = lastName

        // When
        try await registerViewModel.handleRegistrationViewModel()

        // Then
        XCTAssertEqual(registrationRequestBuilder.lastRequest?.email, email)
        XCTAssertEqual(registrationRequestBuilder.lastRequest?.password, password)
        XCTAssertEqual(registrationRequestBuilder.lastRequest?.firstName, firstName)
        XCTAssertEqual(registrationRequestBuilder.lastRequest?.lastName, lastName)
    }

    func testInvalidHandleRegistrationViewModel() async throws {
        // Given
        registrationRequestBuilder.shouldThrowError = true

        // When & Then
        do {
            try await registerViewModel.handleRegistrationViewModel()
            XCTFail("Expected an error to be thrown, but no error was thrown.")
        } catch {
            // Ensure the error is handled correctly
            XCTAssertTrue(error is MockRegistrationRequestBuilder.MockError)
        }
    }
}

class MockRegistrationRequestBuilder: RegistrationRequestBuilder {
    struct MockError: Error {}
    var shouldThrowError = false
    var lastRequest: RegistrationRequestBody?

     func buildRegistrationRequest(email: String, password: String, firstName: String, lastName: String) async throws -> RegistrationRequestBody {
        if shouldThrowError {
            throw MockError()
        }
        let request = RegistrationRequestBody(email: email, password: password, firstName: firstName, lastName: lastName)
        lastRequest = request
        return request
    }
}

class MockLoginViewModel: LoginViewModel {
    // Mock implementation if needed
}
