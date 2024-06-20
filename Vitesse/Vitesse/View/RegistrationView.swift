import SwiftUI

struct RegistrationView: View {
    @StateObject var registerViewModel: RegisterViewModel
    @State private var registre: Bool = false
    @StateObject var loginViewModel: LoginViewModel
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isEmailValid: Bool = true
    @State private var isPasswordValid: Bool = true
    @State private var isFirstNameValid: Bool = true
    @State private var isLastNameValid: Bool = true
    @State private var doPasswordsMatch: Bool = true
    
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
                        textField: "Enter your first name",
                        isValid: $isFirstNameValid
                    )
                    LabeledTextField(
                        textNames: "Last Name",
                        text: $registerViewModel.lastName,
                        textField: "Enter your last name",
                        isValid: $isLastNameValid
                    )
                    
                    Email(
                        textNames: "Email",
                        textField: "Use a valid Email",
                        registerViewModel: registerViewModel,
                        isEmailValid: $isEmailValid
                    ).keyboardType(.emailAddress)
                    
                    PasswordInputField(
                        textField: "Enter your password",
                        text: $registerViewModel.password,
                        textNames: "Password",
                        isPasswordValid: isPasswordValid, registerViewModel: registerViewModel,
                        doPasswordsMatch: $doPasswordsMatch
                    )
                }
                .padding()
                
                Button("Create") {
                    Task {
                        isFirstNameValid = !registerViewModel.firstName.isEmpty
                        isLastNameValid = !registerViewModel.lastName.isEmpty
                        isEmailValid = registerViewModel.textFieldValidatorEmail(registerViewModel.email)
                        isPasswordValid = registerViewModel.textFieldValidatorPassword(registerViewModel.password)
                        doPasswordsMatch = registerViewModel.password == registerViewModel.confirm_password
                        
                        if isFirstNameValid && isLastNameValid && isEmailValid && isPasswordValid && doPasswordsMatch {
                            do {
                                try await registerViewModel.handleRegistrationViewModel()
                            } catch {
                                alertMessage = "Error while creating the account: \(error.localizedDescription)"
                                showingAlert = true
                            }
                        } else {
                            alertMessage = "Please verify that all fields are correctly filled and passwords match."
                            showingAlert = true
                        }
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.orange)
                .cornerRadius(10)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Erreur"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .padding()
        }
    }
}

struct LabeledTextField: View {
    var textNames: String
    @Binding var text: String
    var textField: String
    @Binding var isValid: Bool
    
    var body: some View {
        Group {
            Text(textNames).foregroundColor(.orange)
            TextField(textField, text: $text, onEditingChanged: { (isChanged) in
                if !isChanged {
                    self.isValid = !self.text.isEmpty
                    if !self.isValid {
                        self.text = ""
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
                    .opacity(self.isValid ? 0 : 1)
                    .animation(.default)
                , alignment: .trailing
            )
            if !self.isValid && !self.text.isEmpty {
                Text("\(textNames) is required")
                    .font(.callout)
                    .foregroundColor(Color.red)
                    .padding(.top, 5)
            }
        }
    }
}

struct Email: View {
    var textNames: String
    var textField: String
    @ObservedObject var registerViewModel: RegisterViewModel
    @Binding var isEmailValid: Bool
    
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
    @State var isPasswordValid: Bool = true
    @ObservedObject var registerViewModel: RegisterViewModel
    @Binding var doPasswordsMatch: Bool
    
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
            SecureField("Enter your password", text: $registerViewModel.confirm_password)
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
                        .opacity(self.doPasswordsMatch ? 0 : 1)
                        .animation(.default)
                    , alignment: .trailing
                )
            
            if !self.isPasswordValid && !self.registerViewModel.password.isEmpty {
                Text("Password must be at least 8 characters long")
                    .font(.callout)
                    .foregroundColor(Color.red)
                    .padding(.top, 5)
            }
            
            if !self.doPasswordsMatch && !self.registerViewModel.confirm_password.isEmpty {
                Text("Passwords do not match")
                    .font(.callout)
                    .foregroundColor(Color.red)
                    .padding(.top, 5)
            }
        }
    }
}
