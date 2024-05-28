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
    let vitesseViewModel : VitesseViewModel
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding()
                    Image("running_").frame(width: 100,height: 100)
                    VStack {
                        Text("Email/Username")
                            .foregroundColor(.white)
                        TextField("Entrez un Email ou Username valide", text: $AuthenticationView.username)
                            .disableAutocorrection(true)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack {
                        Text("Password")
                            .foregroundColor(.white)
                            .font(.title3)
                        SecureField("Veuillez entrez un mot de passe vaide", text: $AuthenticationView.password)
                            .textFieldStyle(.roundedBorder)
                        
                    }
                    .padding()
                    
                    Button("Sign in") {
                        Task { @MainActor in
                            try? await AuthenticationView.authenticateUserAndProceed()
                        }
                    }
                    .frame(width: 100, height: 50)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
                    
                   
                    
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
                .padding()
            }
        }
    }
}
