//
//  ContentView.swift
//  Vitesse
//
//  Created by KEITA on 11/05/2024.
//

import SwiftUI

struct LoginView: View {
    @State var register: Bool = false
    @ObservedObject var loginViewModel: LoginViewModel
    let vitesseViewModel: VitesseViewModel
    @State private var rotationAngle: Double = 0

    var body: some View {
        NavigationStack {
            ZStack {
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
                        }

                    VStack {
                        Text("Email/Username")
                            .foregroundColor(.white)

                        TextField("Entrez un Email ou Username valide", text: $loginViewModel.username)
                            .padding()
                            .cornerRadius(5.0)
                            .foregroundColor(.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.orange, lineWidth: 2)
                            )

                        Text("Password")
                            .foregroundColor(.white)
                            .font(.title3)

                        SecureField("Veuillez entrez un mot de passe valide", text: $loginViewModel.password)
                            .padding()
                            .cornerRadius(5.0)
                            .foregroundColor(.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.orange, lineWidth: 2)
                            )

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
                    .background(Color.orange)
                    .cornerRadius(35)

                    Button("Register") {
                        register = true
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(35)
                    .sheet(isPresented: $register) {
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
