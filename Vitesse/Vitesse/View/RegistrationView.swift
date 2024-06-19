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
                        text: $registerViewModel.firstName,
                        textField: "Enter your first name"
                    )
                    LabeledTextField(
                        textNames: "Last Name",
                        text: $registerViewModel.lastName,
                        textField: "Enter your last name"
                    )
                    
                    Email(
                        textNames: "Email",
                        textField: "Use a valid Email",
                        registerViewModel: registerViewModel
                    ).keyboardType(.emailAddress)
                    
                    PasswordInputField(
                        textField: "Enter your password",
                        text: $registerViewModel.password,
                        textNames: "Password", registerViewModel: registerViewModel
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
    var textNames: String
    @Binding var text: String
    var textField: String
    
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
    var textNames: String
    var textField: String
    @ObservedObject var registerViewModel: RegisterViewModel
    @State var isEmailValid: Bool = true
    
    var body: some View {
        Group {
            Text(textNames).foregroundColor(.orange)
            TextField(textField, text: $registerViewModel.email, onEditingChanged: { (isChanged) in
                if !isChanged {
                    self.isEmailValid = registerViewModel.textFieldValidatorEmail(self.registerViewModel.email)
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
            .overlay(
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
                    .padding(.trailing, 8)
                    .opacity(self.isEmailValid ? 0 : 1)
                    .animation(.default)
                , alignment: .trailing
            )
            if !self.isEmailValid && !self.registerViewModel.email.isEmpty {
                Text("Email is Not Valid")
                    .font(.callout)
                    .foregroundColor(Color.red)
                    .padding(.top, 5)
            }
        }
    }
}

struct PasswordInputField: View {
    var textField: String
    @Binding var text: String
    var textNames: String
    @State var  isPasswordValid : Bool = true
    @ObservedObject var registerViewModel: RegisterViewModel

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
                ).overlay(
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                        .padding(.trailing, 8)
                        .opacity(self.isPasswordValid ? 0 : 1)
                        .animation(.default)
                    , alignment: .trailing
                )
            
            Text("Confirmer le mot de passe").foregroundColor(.orange)
            SecureField(textField, text: $registerViewModel.confirme_password)
                .padding()
                .cornerRadius(5.0)
                .foregroundColor(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 2)
                ).overlay(
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                        .padding(.trailing, 8)
                        .opacity(self.isPasswordValid ? 0 : 1)
                        .animation(.default)
                    , alignment: .trailing
                )
            
            if !self.isPasswordValid && !self.registerViewModel.password.isEmpty {
                Text("Password must be at least 8 characters long")
                    .font(.callout)
                    .foregroundColor(Color.red)
                    .padding(.top, 5)
            }
                
        }
    }
}
