import SwiftUI

struct RegistrationView: View {
    @StateObject var registerViewModel: RegisterViewModel
    @State private var registre: Bool = false
    @StateObject var loginViewModel: LoginViewModel

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
                    LabeledTextField(
                        textNames: "First Name",
                        text: registerViewModel.firstName,
                        textField: "Enter your last name"
                    )
                    LabeledTextField(
                        textNames: "Last Name",
                        text: registerViewModel.lastName,
                        textField: "Enter your name"
                    )
                 
                    Email(textNames: "Email", textField: "Use a valid Email", registerViewModel: registerViewModel).keyboardType(.emailAddress).keyboardType(.emailAddress)
                    
                    
                    PasswordInputField(
                        textField: "Enter your password",
                        text: registerViewModel.password,
                        textNames: "Password"
                    )
                    PasswordInputField(
                        textField: "Enter your password",
                        text: registerViewModel.password,
                        textNames: "Confirm Password"
                    )
                }
                .padding()
                
                Button("Create") {
                    Task {
                        do {
                            try await registerViewModel.handleRegistrationViewModel()
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

struct LabeledTextField: View {
    @State var textNames: String = ""
    @State var text: String = ""
    @State var textField: String = ""
    var body: some View {
        Group {
            Text(textNames).foregroundColor(.orange)
            TextField(textField, text: $text)
                .padding()
                .cornerRadius(5.0)
                .foregroundColor(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 2)
                )
        }
    }
}
struct Email: View {
    @State var textNames: String = ""
    @State var text: String = ""
    @State var textField: String = ""
    @ObservedObject var registerViewModel: RegisterViewModel
    @State var isEmailValid: Bool = true

    var body: some View {
        Group {
            Text(textNames).foregroundColor(.orange)
            TextField(textField, text: $text, onEditingChanged: { (isChanged) in
                if !isChanged {
                    self.isEmailValid = registerViewModel.textFieldValidatorEmail( self.registerViewModel.email)
                    if !self.isEmailValid {
                        self.registerViewModel.email = ""
                    }
                }
            })
                .padding()
                .cornerRadius(5.0)
                .foregroundColor(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 2)
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
                        .stroke(Color.black, lineWidth: 2)
                )
        }
    }
}
