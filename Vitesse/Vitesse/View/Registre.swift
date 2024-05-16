//
//  Registre.swift
//  Vitesse
//
//  Created by KEITA on 15/05/2024.
//

import SwiftUI

struct Registre: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
   
    var body: some View {
        ZStack {
            Color.blue.opacity(0.5).ignoresSafeArea()

            VStack {
                
                Text("Registre")
                .font(.largeTitle)
                .fontWeight(.bold)
            .foregroundColor(.blue).padding()
                
                VStack(alignment: .leading){
                    
                    Text("First Name").foregroundColor(.white)
                    TextField("Use First Name valid", text: $firstName)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                 
                    Text("Last Name").foregroundColor(.white)
                    TextField("Use Last Name valid", text: $lastName)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Email").foregroundColor(.white)
                    TextField("Use Email valid ", text: $email)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Password").foregroundColor(.white)
                    .font(.title3)
                    SecureField("Use Password valid", text: $password)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Confirm Password").foregroundColor(.white)
                    .font(.title3)
                    SecureField("Use Password valid", text: $confirmPassword)
                    .textFieldStyle(.roundedBorder)
                    
                    }
                
                Button("Create") {
                    
                }.frame(width: 100,height: 50)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
               
            }
        }
    }
}

