import SwiftUI

struct RegistrationView: View {
    @StateObject var registerViewModel: RegisterViewModel
    @State private var registre: Bool = false
    @StateObject var loginViewModel: LoginViewModel
    @State private var alertMessage = ""
    @State private var isEmailValid: Bool = true
    @State private var isPasswordValid: Bool = true
    @State private var isFirstNameValid: Bool = true
    @State private var isLastNameValid: Bool = true
    @State private var doPasswordsMatch: Bool = true
    @State private var alertMessage_all : String = ""
    @State private var showPicture : Bool = false
    
    var body: some View {
        ZStack {
            if showPicture {
                Image(systemName: "checkmark.shield.fill").resizable().foregroundColor(.green).frame(width: 100,height: 100).opacity(showPicture ? 1 : 0)
            }
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
                        isPasswordValid: $isPasswordValid, registerViewModel: registerViewModel,
                        doPasswordsMatch: $doPasswordsMatch
                    )
                }
                .padding()
                Text(alertMessage_all).foregroundColor(.red)
                Button("Create") {
                    Task {
                        isFirstNameValid = !registerViewModel.firstName.isEmpty
                        isLastNameValid = !registerViewModel.lastName.isEmpty
                        isEmailValid =
                        ValidatorType.email.textFieldValidatorEmail(registerViewModel.email)
                        isPasswordValid =
                        ValidatorType.password.textFieldValidatorPassword(registerViewModel.password)
                        
                        doPasswordsMatch = registerViewModel.password == registerViewModel.confirm_password
                        
                        if isFirstNameValid && isLastNameValid && isEmailValid && isPasswordValid && doPasswordsMatch {
                            do {
                                try await registerViewModel.handleRegistrationViewModel()
                                showPicture = true
                            } catch {
                                alertMessage = "Error while creating the account: \(error.localizedDescription)"
                            }
                        } else {
                            alertMessage_all = "Please verify that all fields are correctly filled and passwords match."
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
                    self.isEmailValid = 
                    ValidatorType.email.textFieldValidatorEmail(self.registerViewModel.email)
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
    @Binding var isPasswordValid: Bool 
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
                        .onAppear {
                            
                            withAnimation(Animation.linear(duration:2)){}
                            
                        }
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
