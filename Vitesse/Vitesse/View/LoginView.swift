//
//  ContentView.swift
//  Vitesse
//
//  Created by KEITA on 11/05/2024.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var AuthenticationView: LoginViewModel
    @State private var registre: Bool = false
    let textFieldGray = Color(red: 0.83, green: 0.83, blue: 0.83)
    let vitesseViewModel : VitesseViewModel
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(.bottom,20)
                    
                    Image("speed")
                        .resizable()
                        .aspectRatio( contentMode: .fill)
                        .frame(width: 150,height: 150)
                        .clipped()
                        .cornerRadius(150).padding(.bottom,75)
                    
                        Text("Email/Username")
                            .foregroundColor(.white)
                        TextField("Entrez un Email ou Username valide", text: $AuthenticationView.username)
                        .padding()
                        .background(textFieldGray)
                        .cornerRadius(5.0)
                        .padding(.bottom,20)
                    
                    VStack {
                        Text("Password")
                            .foregroundColor(.white)
                            .font(.title3)
                        SecureField("Veuillez entrez un mot de passe vaide", text: $AuthenticationView.password)
                            .padding()
                            .background(textFieldGray)
                            .cornerRadius(5.0)
                            .padding(.bottom,20)
                        
                    }
                  
                    
                    Button("Sign in") {
                        Task { @MainActor in
                            try? await AuthenticationView.authenticateUserAndProceed()
                        }
                    }
                    .frame(width: 100, height: 50)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                  
                    
                   
                    
                    Button("Registrer") {
                        registre = true
                    }
                    .frame(width: 100, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .sheet(isPresented: $registre ) {
                        RegistrationView(registreViewModel: vitesseViewModel.registreViewModel, login: LoginViewModel({}))
                    }
                }
            
            }
        }
    }
}
