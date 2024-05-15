//
//  VitesseApp.swift
//  Vitesse
//
//  Created by KEITA on 11/05/2024.
//

import SwiftUI

@main
struct VitesseApp: App {
    let vitesseViewModel = VitesseViewModel()
    var body: some Scene {
        WindowGroup {
            Group {
                if vitesseViewModel.onLoginSucceed {
                    TabView {
                        Candidats().tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("Account")
                        }
                    }
                
                }else{
                    Login(loginViewModel: vitesseViewModel.loginViewModel)
                }
            }
            
        }
    }
}
