import SwiftUI

struct RegistrationView: View {
    @StateObject var registerViewModel: RegisterViewModel
    @State private var isRegistered: Bool = false
    @StateObject var loginViewModel: LoginViewModel
    @State private var isEmailValid: Bool = true
    @State private var isFirstNameValid: Bool = true
    @State private var isLastNameValid: Bool = true
    @State private var alertMessageAll: String = ""
    @State private var showPictureTrue: Bool = false
    @State private var showPictureFalse: Bool = false
    @State var doPasswordsMatch: Bool = true
    @State var isPasswordValid: Bool = true
    @State var isValid: Bool = false
    
    var body: some View {
        ZStack {
            if showPictureTrue {
                Image(systemName: "checkmark.shield.fill").resizable().foregroundColor(.green).frame(width: 100, height: 100).opacity(showPictureTrue ? 1 : 0).onAppear {
                    
                    withAnimation(Animation.linear(duration: 0.5)) {}
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(Animation.linear(duration: 0.5)) {
                            showPictureTrue = false
                        }
                    }
                }
            }
            if showPictureFalse {
                Image(systemName: "checkmark.shield.fill").resizable().foregroundColor(.red).frame(width: 100, height: 100).opacity(showPictureFalse ? 1 : 0).onAppear {
                    
                    withAnimation(Animation.linear(duration: 0.5)) {}
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(Animation.linear(duration: 0.5)) {
                            showPictureFalse = false
                        }
                    }
                }
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
                        label: "First Name",
                        text: $registerViewModel.firstName,
                        placeholder: "Enter your first name",
                        isValid: $isFirstNameValid
                    )
                    LabeledTextField(
                        label: "Last Name",
                        text: $registerViewModel.lastName,
                        placeholder: "Enter your last name",
                        isValid: $isLastNameValid
                    )
                    
                    EmailField(
                        label: "Email",
                        placeholder: "Use a valid email",
                        registerViewModel: registerViewModel,
                        isEmailValid: $isEmailValid
                    ).keyboardType(.emailAddress)
                    
                    PasswordInputField(
                        placeholder: "Enter your password",
                        text: $registerViewModel.password,
                        label: "Password",
                        isPasswordValid: $isPasswordValid,
                        registerViewModel: registerViewModel,
                        doPasswordsMatch: $doPasswordsMatch
                    )
                }
                .padding()
                
                Text(alertMessageAll).foregroundColor(isValid ? .green : .red).onAppear {
                    
                    withAnimation(Animation.linear(duration: 0.5)) {}
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(Animation.linear(duration: 0.5)) {
                            isValid = false
                        }
                    }
                }
                
                Button("Create") {
                    Task {
                        isFirstNameValid = !registerViewModel.firstName.isEmpty
                        isLastNameValid = !registerViewModel.lastName.isEmpty
                        isEmailValid = ValidatorType.email.textFieldValidatorEmail(registerViewModel.email)
                        isPasswordValid = ValidatorType.password.textFieldValidatorPassword(registerViewModel.password)
                        doPasswordsMatch = registerViewModel.password == registerViewModel.confirm_password
                        
                        if isFirstNameValid && isLastNameValid && isEmailValid && isPasswordValid && doPasswordsMatch {
                            do {
                                let _ = try await registerViewModel.handleRegistrationViewModel()
                                showPictureTrue = true
                                alertMessageAll = "Account created successfully. All entered information is valid."
                                isValid = true
                            } catch {
                                alertMessageAll = "Error while creating the account. Please verify the entered information."
                                showPictureFalse = true
                                isValid = false
                            }
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
    var label: String
    @Binding var text: String
    var placeholder: String
    @Binding var isValid: Bool
    
    var body: some View {
        Group {
            Text(label).foregroundColor(.orange)
            TextField(placeholder, text: $text, onEditingChanged: { (isChanged) in
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
                    .onAppear {
                        withAnimation(Animation.linear(duration: 0.5)) {}
                    },
                alignment: .trailing
            )
            if !self.isValid && !self.text.isEmpty {
                Text("\(label) is required")
                    .font(.callout)
                    .foregroundColor(Color.red)
                    .padding(.top, 5)
            }
        }
    }
}

struct EmailField: View {
    var label: String
    var placeholder: String
    @ObservedObject var registerViewModel: RegisterViewModel
    @Binding var isEmailValid: Bool
    
    var body: some View {
        Group {
            Text(label).foregroundColor(.orange)
            TextField(placeholder, text: $registerViewModel.email, onEditingChanged: { (isChanged) in
                if !isChanged {
                    self.isEmailValid = ValidatorType.email.textFieldValidatorEmail(self.registerViewModel.email)
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
                    .onAppear {
                        withAnimation(Animation.linear(duration: 0.5)) {}
                    },
                alignment: .trailing
            )
            if !self.isEmailValid && !self.registerViewModel.email.isEmpty {
                Text("Email is not valid")
                    .font(.callout)
                    .foregroundColor(Color.red)
                    .padding(.top, 5)
            }
        }
    }
}

struct PasswordInputField: View {
    var placeholder: String
    @Binding var text: String
    var label: String
    @Binding var isPasswordValid: Bool
    @ObservedObject var registerViewModel: RegisterViewModel
    @Binding var doPasswordsMatch: Bool
    
    var body: some View {
        Group {
            Text(label).foregroundColor(.orange)
            SecureField(placeholder, text: $text)
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
                            withAnimation(Animation.linear(duration: 0.5)) {}
                        },
                    alignment: .trailing
                )
            
            if !self.isPasswordValid && !self.registerViewModel.password.isEmpty {
                Text("Password must be at least 6 characters long")
                    .font(.callout)
                    .foregroundColor(Color.red)
                    .padding(.top, 5)
            }
            
            Text("Confirm Password").foregroundColor(.orange)
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
                        .onAppear {
                            withAnimation(Animation.linear(duration: 0.5)) {}
                        },
                    alignment: .trailing
                )
            
            if registerViewModel.confirm_password != registerViewModel.password {
                Text("Passwords do not match")
                    .font(.callout)
                    .foregroundColor(Color.red)
                    .padding(.top, 5)
            }
        }
    }
}
