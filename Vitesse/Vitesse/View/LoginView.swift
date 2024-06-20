import SwiftUI

struct LoginView: View {
    var vitesseViewModel: VitesseViewModelManager
    @State var register: Bool = false
    @StateObject var loginViewModel: LoginViewModel
    @State private var rotationAngle: Double = 0
    @State private var showingAlert = false
    @State private var isEmailValid: Bool = true
    @State private var isPasswordValid: Bool = true
    @State private var alertMessage : String = ""
    @State private var alertMessage_all : String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.orange.opacity(0.2) // Fond orange clair
                    .ignoresSafeArea()
                
                VStack {
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                        .padding(.bottom, 20)
                    
                    Image("Vitesse")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .rotationEffect(.degrees(rotationAngle))
                        .onAppear {
                            withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
                                rotationAngle = 360
                            }
                        }
                        .padding(.bottom, 20)
                    
                    VStack(alignment: .leading) {
                        extraireIdentifiantsUtilisateurs(loginViewModel: loginViewModel, textField: "Entrez un Email ou Username valide", textName: "Email/Username", isEmailValid: $isEmailValid, isPasswordValid: $isPasswordValid)
                            .padding(.bottom, 20)
                        
                        extraireIdentifiantsUtilisateurs(loginViewModel: loginViewModel, textField: "Veuillez entrez un mot de passe valide", textName: "Password", isEmailValid: $isEmailValid, isPasswordValid: $isPasswordValid)
                            .padding(.bottom, 20)
                    }
                    
                    Text(alertMessage_all).foregroundColor(.red)
                    
                    AuthButton(title: "Sign in", loginViewModel: loginViewModel, register: $register, alertMessage: $alertMessage, isPasswordValid: $isPasswordValid, isEmailValid: $isEmailValid, alertMessage_all: $alertMessage_all)
                        .padding(.bottom, 10)
                    
                    AuthButton(title: "Register", loginViewModel: loginViewModel, register: $register, alertMessage: .constant(""), isPasswordValid: $isPasswordValid, isEmailValid: $isEmailValid, alertMessage_all: $alertMessage_all)
                        .sheet(isPresented: $register) {
                            RegistrationView(
                                registerViewModel: vitesseViewModel.registerViewModel,
                                loginViewModel: LoginViewModel({})
                            )
                        }
                        .padding(.bottom, 10)
                }
                .padding()
            }
        }
    }
}

struct extraireIdentifiantsUtilisateurs: View {
    @ObservedObject var loginViewModel: LoginViewModel
    var textField: String = ""
    var textName: String = ""
    @Binding var isEmailValid: Bool
    @Binding var isPasswordValid: Bool
    
    var body: some View {
        VStack {
            Text(textName)
                .foregroundColor(.orange)
            
            if textName == "Email/Username" {
                TextField(textField, text: $loginViewModel.username, onEditingChanged: { (isChanged) in
                    if !isChanged {
                        self.isEmailValid = 
                        ValidatorType.email.textFieldValidatorEmail(self.loginViewModel.username)
                        if !self.isEmailValid {
                            self.loginViewModel.username = ""
                            loginViewModel.message = "Please check the email or username"
                        }
                    }
                })
                .padding()
                .textContentType(.emailAddress)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
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
                            
                            withAnimation(Animation.linear(duration:2)){}
                            
                        }
                    , alignment: .trailing
                )
                
                if !self.isEmailValid && !self.loginViewModel.username.isEmpty {
                    Text("Email is Not Valid")
                        .font(.callout)
                        .foregroundColor(Color.red)
                        .padding(.top, 5)
                }
            } else {
                SecureField(textField, text: $loginViewModel.password)
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
                            .opacity(self.isPasswordValid ? 0 : 1)
                            .onAppear {
                                
                                withAnimation(Animation.linear(duration:2)){}
                                
                            }
                        , alignment: .trailing
                    )
                
                if !self.isPasswordValid && !self.loginViewModel.password.isEmpty {
                    Text("Password must be at least 6 characters long")
                        .font(.callout)
                        .foregroundColor(Color.red)
                        .padding(.top, 5)
                }
            }
        }
    }
}

struct AuthButton: View {
    var title: String = ""
    @ObservedObject var loginViewModel: LoginViewModel
    @Binding var register: Bool
    @Binding var alertMessage: String
    @Binding var isPasswordValid: Bool
    @Binding var isEmailValid: Bool
    @Binding var alertMessage_all : String
    
    var body: some View {
        Button(title) {
            if title == "Sign in" {
                // Validate fields before attempting to authenticate
                self.isEmailValid = loginViewModel.textFieldValidatorEmail(loginViewModel.username)
                self.isPasswordValid = loginViewModel.textFieldValidatorPassword(loginViewModel.password)
                
                if self.isEmailValid && self.isPasswordValid {
                    Task { @MainActor in
                        do {
                            try await loginViewModel.authenticateUserAndProceed()
                            if loginViewModel.isLoggedIn {
                                
                            } else {
                                alertMessage = "Authentication failed. Please try again."
                            }
                            
                        } catch {
                            alertMessage_all = "Please check the email/username and password fields."
                        }
                    }
                } else {
                    // Update the alert message based on which fields are invalid
                    if !self.isEmailValid && !self.isPasswordValid {
                        alertMessage = "Please check the email/username and password fields."
                    } else if !self.isEmailValid {
                        alertMessage = "Please check the email/username field."
                    } else if !self.isPasswordValid {
                        alertMessage = "Please check the password field."
                    }
                }
            } else {
                register = true
            }
        }
        .font(.headline)
        .foregroundColor(.white)
        .padding()
        .background(Color.orange)
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
}
