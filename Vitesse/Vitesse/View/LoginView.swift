import SwiftUI

struct LoginView: View {
    @State var register: Bool = false
    @State var loginViewModel: LoginViewModel
    let vitesseViewModel: VitesseViewModel
    @State private var rotationAngle: Double = 0

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
                        }.padding(.bottom,20)

                    VStack (alignment: .leading){
                        Text("Email/Username")
                            .foregroundColor(.orange)

                        TextField("Entrez un Email ou Username valide", text: $loginViewModel.username)
                            .padding()
                            .cornerRadius(5.0)
                            .foregroundColor(.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 2)
                            )

                        Text("Password")
                            .foregroundColor(.orange)
                            .font(.title3)

                        SecureField("Veuillez entrez un mot de passe valide", text: $loginViewModel.password)
                            .padding()
                            .cornerRadius(5.0)
                            .foregroundColor(.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 2)
                            )

                    }
                    .padding(.bottom, 20)

                    ExtractedView(title:"Sign in",loginViewModel: $loginViewModel, register: $register)

                    ExtractedView(title:"Register",loginViewModel: $loginViewModel, register: $register).sheet(isPresented: $register) {
                        RegistrationView(
                            registerViewModel: vitesseViewModel.registerViewModel,
                            login: LoginViewModel({})
                        )
                    }
                     
                }
                .padding()
            }
        }
    }
}

struct ExtractedView: View {
    var title : String = ""
    @Binding var loginViewModel : LoginViewModel
    @Binding var register : Bool
    var body: some View {
        Button(title) {
            
            if title == "Sign in"{
                Task { @MainActor in
                    try? await loginViewModel.authenticateUserAndProceed()
                }
            }else{
                register = true
            }
            
        }
        .font(.headline)
        .foregroundColor(.white)
        .padding()
        .background(Color.orange)
        .cornerRadius(10)
        .frame(maxWidth: .infinity)// Ajustement de la largeur du bouton
    }
}
