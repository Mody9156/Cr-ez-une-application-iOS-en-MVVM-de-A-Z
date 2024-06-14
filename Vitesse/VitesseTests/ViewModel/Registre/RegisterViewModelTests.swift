import XCTest
@testable import Vitesse

final class RegisterViewModelTests: XCTestCase {
    var registerViewModel: RegisterViewModel!
    var registrationRequestBuilder: RegistrationRequestBuilder!
    var loginViewModel: MockLoginViewModel!
    override func setUp() {
        registrationRequestBuilder = MockRegistrationRequestBuilder()
        loginViewModel = MockLoginViewModel({})
        registerViewModel = RegisterViewModel(registrationRequestBuilder: RegistrationRequestBuilder(), loginViewModel: LoginViewModel({}))
        super.setUp()
    }
    
    override func tearDown() {
        registerViewModel = nil
        registrationRequestBuilder = nil
        loginViewModel = nil
        super.tearDown()
    }
    
    //    func testHandleRegistrationViewModel() async throws {
    //        // Given
    //        let email = "test@example.com"
    //        let password = "securePassword123"
    //        let firstName = "John"
    //        let lastName = "Doe"
    //
    //        registerViewModel.email = email
    //        registerViewModel.password = password
    //        registerViewModel.firstName = firstName
    //        registerViewModel.lastName = lastName
    //
    //        do {
    //            // When
    //            let buildRegistrationResponse = try await registrationRequestBuilder.buildRegistrationRequest(email: email, password: password, firstName: firstName, lastName: lastName)
    //
    //            // Then
    //            XCTAssertEqual(buildRegistrationResponse.statusCode, expectedStatusCode)
    //            // Compare other properties of the response as needed
    //        } catch {
    //            XCTFail("An error occurred: \(error)")
    //        }
    //    }
    
    
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
            let _: () = try await registerViewModel.handleRegistrationViewModel()
            XCTFail("Expected invalid response error")
            
        }catch{
            
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
