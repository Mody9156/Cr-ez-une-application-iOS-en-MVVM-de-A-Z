//
//  Candidats.swift
//  Vitesse
//
//  Created by KEITA on 14/05/2024.
//

import SwiftUI

struct CandidatesListView: View {
    @StateObject var candidateViewModel : CandidateViewModel
    @State private var search = ""
    
    var body: some View {
        NavigationStack {
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
                    Text("Searching for \(search)")
                    VStack{
                        
                        
                        List{
                            ForEach(candidateViewModel.candidats,id: \.self){ element in
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
            }.searchable(text: $search)
        }
    }
}
