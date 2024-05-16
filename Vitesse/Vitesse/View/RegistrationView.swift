//
//  Registre.swift
//  Vitesse
//
//  Created by KEITA on 15/05/2024.
//

import SwiftUI

struct RegistrationView: View {

    @StateObject var registreViewModel : RegistreViewModel
   
    var body: some View {
        ZStack {
            Color.blue.opacity(0.5).ignoresSafeArea()

            VStack {
                
                Text("Registre")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding()
                
                VStack(alignment: .leading){
                    
                    Text("First Name").foregroundColor(.white)
                    TextField("Use First Name valid", text: $registreViewModel.firstName)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                 
                    Text("Last Name").foregroundColor(.white)
                    TextField("Use Last Name valid", text: $registreViewModel.lastName)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Email").foregroundColor(.white)
                    TextField("Use Email valid ", text: $registreViewModel.email)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                    
                    Text("Password").foregroundColor(.white)
                        .font(.title3)
                    SecureField("Use Password valid", text: $registreViewModel.password)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Confirm Password").foregroundColor(.white)
                        .font(.title3)
                    SecureField("Use Password valid", text: $registreViewModel.password)
                        .textFieldStyle(.roundedBorder)
                }
                
                Button("Create") {
                    Task{
                        try await registreViewModel.handleRegistrationViewModel()
                    }
                }
                .frame(width: 100, height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
               
            }
        }
    }
}
