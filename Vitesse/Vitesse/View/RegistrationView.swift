import SwiftUI

struct RegistrationView: View {
    @State var registerViewModel = RegisterViewModel(registrationRequestBuilder: RegistrationRequestBuilder(httpService: URLSessionHTTPClient()), loginViewModel: LoginViewModel({}))
    @State private var registre: Bool = false
    @State var login: LoginViewModel

    var body: some View {
        ZStack {
            Color.orange.opacity(0.2) // Light orange background
                .ignoresSafeArea()
            VStack {
                Text("Register")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
                    .padding(.bottom, 20)

                VStack(alignment: .leading) {
                    FetchRegister( infos: "First Name", text: registerViewModel.firstName, textField: "Use a valid First Name")
                    FetchRegister( infos: "Last Name", text: registerViewModel.lastName, textField: "Use a valid Last Name")
                    FetchRegister(infos: "Email", text: registerViewModel.email, textField: "Use a valid Email")

                    PasswordInputField( textField:"Enter your password", text:registerViewModel.password, textNames: "Password")
                    PasswordInputField( textField:"Use a valid Password", text:registerViewModel.password, textNames: "Confirm Password")
                }
                .padding()

                Button("Create") {
                    Task {
                        do {
                            try await registerViewModel.handleRegistrationViewModel()
                            self.login.username = registerViewModel.email
                        } catch {
                            print("Error while creating the account: \(error)")
                        }
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.orange)
                .cornerRadius(10)
            }
            .padding()
        }
    }
}

struct FetchRegister: View {
    @State var infos: String = ""
    @State var text: String = ""
    @State var textField: String = ""
    
    var body: some View {
        Group {
            Text(infos).foregroundColor(.orange)
            TextField(textField, text: $text)
                .padding()
                .cornerRadius(5.0)
                .foregroundColor(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.orange, lineWidth: 2)
                )
        }
    }
}

struct PasswordInputField: View {
    @State var textField: String = ""
    @State var text: String = ""
    @State var textNames: String = ""
    
    var body: some View {
        Group {
            Text(textNames).foregroundColor(.orange)
            SecureField(textField, text: $text)
                .padding()
                .cornerRadius(5.0)
                .foregroundColor(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.orange, lineWidth: 2)
                )
        }
    }
}
