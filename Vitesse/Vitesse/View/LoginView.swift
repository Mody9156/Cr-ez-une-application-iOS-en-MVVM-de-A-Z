//
//  ContentView.swift
//  Vitesse
//
//  Created by KEITA on 11/05/2024.
//

import SwiftUI

struct LoginView: View {
    @State var registre: Bool = false
    @ObservedObject var loginViewModel : LoginViewModel
    let textFieldGray = Color(red: 0.83, green: 0.83, blue: 0.83)
    let vitesseViewModel: VitesseViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                VStack {
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        
                    
                    Image("running")
                        .resizable()
                        .aspectRatio(contentMode: .fill).ignoresSafeArea()
                        .clipped()
                        .cornerRadius(75) // Adjusted to 75 to make it a circle
                        
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Email/Username")
                            .foregroundColor(.white)
                        
                        TextField(("Entrez un Email ou Username valide"), text: $loginViewModel.username)
                            .padding()
                            .background(textFieldGray)
                            .cornerRadius(5.0)
                            .foregroundColor(.black)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)

                        
                        Text("Password")
                            .foregroundColor(.white)
                            .font(.title3)
                        
                        SecureField(("Veuillez entrez un mot de passe valide"), text: $loginViewModel.password)
                            .padding()
                            .background(textFieldGray)
                            .cornerRadius(5.0)
                            .foregroundColor(.black)
                        
                        Text(loginViewModel.message).foregroundColor(.red)
                        
                    }
                    .padding(.bottom, 20)
                    
                    Button("Sign in") {
                        Task { @MainActor in
                       try? await loginViewModel.authenticateUserAndProceed()
                            
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.black)
                    .cornerRadius(35)
                    
                    Button("Register") {
                        registre = true
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.black)
                    .cornerRadius(35)
                    .sheet(isPresented: $registre) {
                        RegistrationView(registreViewModel: vitesseViewModel.registreViewModel, login: LoginViewModel({}))
                    }
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginViewModel: LoginViewModel({}), vitesseViewModel: VitesseViewModel())
    }
}
