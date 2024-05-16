//
//  VitesseApp.swift
//  Vitesse
//
//  Created by KEITA on 11/05/2024.
//

import SwiftUI

@main
struct VitesseApp: App {
    @StateObject var vitesseViewModel = VitesseViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if vitesseViewModel.onLoginSucceed {
                    TabView {
                        CandidatesListView()
                            .tabItem {
                                Image(systemName: "person.crop.circle")
                                Text("Candidats")
                            }
                    }
                } else {
                    Login(AuthenticationView: vitesseViewModel.loginViewModel, vitesseViewModel: vitesseViewModel)
                }
            }
        }
    }
}
