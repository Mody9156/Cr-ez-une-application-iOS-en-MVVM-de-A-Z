//
//  ContentView.swift
//  Vitesse
//
//  Created by KEITA on 11/05/2024.
//

import SwiftUI

struct Login: View {
    @ObservedObject var loginViewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.5).ignoresSafeArea()
            VStack {
     
                    Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue).padding()
                
                VStack{
                    Text("Email/Username").foregroundColor(.white)
                    TextField("Entrez un Email ou Username valide", text: $loginViewModel.username).disableAutocorrection(true)
                            .textFieldStyle(.roundedBorder)
                    }
                VStack{
                        Text("Password").foregroundColor(.white)
                        .font(.title3)
                    SecureField("Veuillez entrez un mot de passe vaide", text: $loginViewModel.password)
                        .textFieldStyle(.roundedBorder)
                        
                }.padding()
                
                Button("Sign in") {
                    
                }.frame(width: 100,height: 50).foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(10)
                
                Button("Registrer") {
                    
                }.frame(width: 100,height: 50)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                
            }
            .padding()
        }
    }
}

