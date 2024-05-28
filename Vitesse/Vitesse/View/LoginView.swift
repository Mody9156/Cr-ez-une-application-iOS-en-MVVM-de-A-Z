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
    @State private var rotationAngle: Double = 0

    var body: some View {
        NavigationStack {
            ZStack {
              
                VStack {
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.bottom,20)
                    
                    Image("Vitesse")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle()).rotationEffect(.degrees(rotationAngle))
                        .onAppear {
                            withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
                                rotationAngle = 360
                            }
                        }


                    
                    VStack {
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
                    .background(Color.black)
                    .cornerRadius(35)
                    
                    Button("Register") {
                        registre = true
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(35)
                    .sheet(isPresented: $registre) {
                        RegistrationView(registreViewModel: vitesseViewModel.registreViewModel, login: LoginViewModel({}))
                    }
                }.padding()
               
            }
        }
    }
}
