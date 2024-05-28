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
                    
                        Text("Password")
                            .foregroundColor(.white)
                            .font(.title3)
                        SecureField("Veuillez entrez un mot de passe valide", text: $AuthenticationView.password)
                            .padding()
                            .background(textFieldGray)
                            .cornerRadius(5.0)
                            .padding(.bottom,20)
                    
                    LoginButtonContent(authentification: AuthenticationView)
                    
                    Button("Registrer") {
                        registre = true
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.black)
                    .cornerRadius(35)
                    .sheet(isPresented: $registre ) {
                        RegistrationView(registreViewModel: vitesseViewModel.registreViewModel, login: LoginViewModel({}))
                    }
                }.padding()
            
            }
        }
    }
}


struct LoginButtonContent : View {
    let authentification : LoginViewModel
    var body: some View {
        Button("Sign in") {
            Task { @MainActor in
                try? await authentification.authenticateUserAndProceed()
            }
        }
        .font(.headline)
        .foregroundColor(.white)
        .padding()
        .frame(width: 220, height: 60)
        .background(Color.black)
        .cornerRadius(35)
    }
}
