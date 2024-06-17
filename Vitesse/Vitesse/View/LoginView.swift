import SwiftUI

struct LoginView: View {
    @State var register: Bool = false
    @StateObject var loginViewModel: LoginViewModel
    @State private var rotationAngle: Double = 0
    var vitesseViewModel: VitesseViewModel
    @State private var showingAlert = false
    @State private var isEmailValid : Bool   = true
    
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
                        AuthExtractor(loginViewModel: loginViewModel, textField: "Entrez un Email ou Username valide", textName: "Email/Username", isEmailValid: $isEmailValid)
                        
                        
                        AuthExtractor(loginViewModel: loginViewModel, textField: "Veuillez entrez un mot de passe valide", textName: "Password", isEmailValid: $isEmailValid)
                    }
                    .padding(.bottom, 20)
                    
                    AuthButton(title: "Sign in", loginViewModel: loginViewModel, register: $register, showingAlert: $showingAlert)
                        .alert(loginViewModel.message, isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
                    //insérer un text
                    
                    
                    AuthButton(title: "Register", loginViewModel: loginViewModel, register: $register, showingAlert: $showingAlert)
                        .sheet(isPresented: $register) {
                            RegistrationView(
                                registerViewModel: vitesseViewModel.registerViewModel,
                                loginViewModel: LoginViewModel({})
                            )
                        }
                    //insérer un text 
                }
                .padding()
            }
        }
    }
}

struct AuthExtractor: View {
    @ObservedObject var loginViewModel: LoginViewModel
    var textField: String = ""
    var textName: String = ""
    @Binding var isEmailValid: Bool
    var body: some View {
      
        Text(textName)
            .foregroundColor(.orange)
        if textName == "Email/Username" {
            TextField(textField, text: $loginViewModel.username,onEditingChanged: { (isChanged) in
                if isChanged {
                           // Reset seulement à la fin de l'édition
                           self.isEmailValid = loginViewModel.textFieldValidatorEmail(self.loginViewModel.username)
                           if !self.isEmailValid {
                               self.loginViewModel.username = ""
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
            if !self.isEmailValid && !self.loginViewModel.username.isEmpty {
                    Text("Email is Not Valid")
                        .font(.callout)
                        .foregroundColor(Color.red)
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
        }
    }
}

struct AuthButton: View {
    var title: String = ""
    @ObservedObject var loginViewModel: LoginViewModel
    @Binding var register: Bool
    @Binding var showingAlert : Bool
    var body: some View {
        Button(title) {
            if title == "Sign in" {
                Task { @MainActor in
                    try? await loginViewModel.authenticateUserAndProceed()
                }
                if loginViewModel.isLoggedIn {
                    showingAlert = false
                }else{
                    showingAlert = true
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
        // Ajustement de la largeur du bouton
    }
}
