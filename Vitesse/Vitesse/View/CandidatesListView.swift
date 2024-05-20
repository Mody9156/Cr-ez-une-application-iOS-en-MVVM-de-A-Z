//
//  Candidats.swift
//  Vitesse
//
//  Created by KEITA on 14/05/2024.
//

import SwiftUI

struct CandidatesListView: View {
   @StateObject var candidateViewModel : CandidateViewModel
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.5).ignoresSafeArea()
            VStack {
                HStack {
                    Button("Cancel") {
                        
                    }
                    .frame(width: 100, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Text("Candidats")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding()
                    
                    Button("Delete") {
                        
                    }
                    .frame(width: 100, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                Spacer()
                
                VStack{
                        
                    List(candidateViewModel.candidats) { element in
                        
                        HStack {
                            Text(element.lastName)
                            Text(element.firstName)
                        }
                    }
                    
                    
                }.onAppear{
                    Task{@MainActor in
                        try await candidateViewModel.fetchtoken()
                    }
                }
            }
        }
    }
}
