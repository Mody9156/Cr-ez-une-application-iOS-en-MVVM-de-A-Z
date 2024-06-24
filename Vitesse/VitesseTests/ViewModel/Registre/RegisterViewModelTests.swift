import XCTest
@testable import Vitesse

final class RegisterViewModelTests: XCTestCase {
    var registerViewModel: RegisterViewModel!
    var registrationRequestBuilder: RegistrationRequestBuilder!
    
    override func setUp() {
        registrationRequestBuilder = MockRegistrationRequestBuilder()
        registerViewModel = RegisterViewModel(registrationRequestBuilder: RegistrationRequestBuilder(), loginViewModel: LoginViewModel({}))
        super.setUp()
    }
    
    override func tearDown() {
        registerViewModel = nil
        registrationRequestBuilder = nil
        super.tearDown()
    }
    
    func testHandleRegistrationViewModel() async throws {
        // Given
        let email = "test@example.com"
        let password = "securePassword1"
        let firstName = "John"
        let lastName = "Doe"
        
        registerViewModel.email = email
        registerViewModel.password = password
        registerViewModel.firstName = firstName
        registerViewModel.lastName = lastName
        
        
        do {
            // When
            let buildRegistrationResponse = try await registerViewModel.handleRegistrationViewModel()
            
            // Then
            XCTAssertEqual(buildRegistrationResponse.statusCode, 200)
            XCTAssertEqual(buildRegistrationResponse.message, "Registration successful")
            // Compare other properties of the response as needed
        } catch let error as RegisterViewModel.RegisterViewModelError {
            XCTAssertEqual(error, .invalidHandleRegistrationViewModel)
        }
    }
    
    func testInvalidHandleRegistrationViewModel() async throws {
        // Given
        let email = "test@example.com"
        let password = "securePassword123"
        let firstName = ""
        let lastName = "Doe"
        
        registerViewModel.email = email
        registerViewModel.password = password
        registerViewModel.firstName = firstName
        registerViewModel.lastName = lastName
        
        
        // When & Then
        do{
            let _ = try await registerViewModel.handleRegistrationViewModel()
            XCTFail("Expected invalid response error")
            
        }catch let error as RegisterViewModel.RegisterViewModelError{
            XCTAssertEqual(error, .invalidHandleRegistrationViewModel)
        }
    }
    
    func testTextFieldValidatorPassword(){
        //Given
        
        let password = "simple_test"
        
        //When
        let textFieldValidatorPassword =
        ValidatorType.password.textFieldValidatorPassword(password)
        
        //Then
        XCTAssertTrue(textFieldValidatorPassword)
    }
    
    
    func testFailTextFieldValidatorEmail()async throws{
        //Given
        let email = "exemplede"
        let email_1 = "abcdefghijABCDEFGHIJklmnopqrstKLMNOPQRSTuvwxyzUVWXYZabcdefghijABCDEFGHIJklmnopqrstKLMNOPQRSTuvwxyzUVWX@example.com"
        //When
        let textFieldValidatorEmail =
        ValidatorType.email.textFieldValidatorEmail(email)
        let textFieldValidatorEmail_1 =
        ValidatorType.email.textFieldValidatorEmail(email_1)
        //Then
        XCTAssertFalse(textFieldValidatorEmail)
        XCTAssertTrue(email_1.count > 100  )
        
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


// Mock HTTPService utilisé pour simuler les réponses HTTP
class MockHTTPService: HTTPService {
    
    var mockResult: (Data, HTTPURLResponse)?
    
    func request(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        guard let result = mockResult else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        return result
    }
}

