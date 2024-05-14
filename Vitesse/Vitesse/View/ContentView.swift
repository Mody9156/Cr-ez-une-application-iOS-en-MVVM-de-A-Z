//
//  ContentView.swift
//  Vitesse
//
//  Created by KEITA on 11/05/2024.
//

import SwiftUI

struct ContentView: View {
   @State private var username = ""
   @State private var password = ""
    
    
    var body: some View {
        VStack {
            
                Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue).padding()
            
            VStack{
                    Text("Email/Username")
                    TextField("Entrez un Email ou Username valide", text: $username).disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                }
            VStack{
                    Text("Password")
                    .font(.title3)
                    SecureField("Veuillez entrez un mot de passe vaide", text: $password)
                    .textFieldStyle(.roundedBorder)
                    
                }

            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
