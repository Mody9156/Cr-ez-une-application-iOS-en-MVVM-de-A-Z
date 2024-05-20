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
                        Button("Edit") {
                            
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
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "star.fill")
                        }  .frame(width: 100, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)

                       
                      
                    }
                    Spacer()
                    VStack{
                        
                        
                        List{
                            ForEach(searchResult,id: \.self){ element in
                                HStack {
                                    Text(element.lastName)
                                    Text(element.firstName)
                                    Image(systemName: "star.fill").foregroundColor(element.isFavorite ? .yellow : .black)
                                }
                            }
                            
                            
                        }.onAppear{
                            Task{@MainActor in
                                try await candidateViewModel.fetchtoken()
                            }
                        }
                    }
                }
            }.searchable(text: $search).listStyle(.plain)
                .listRowBackground(Color.clear)
                .listSectionSeparator(.hidden, edges: .bottom)//gerer l'affichage de la list
        }
    }
    
    var searchResult : [RecruitTech] {
        if search.isEmpty {
            return candidateViewModel.candidats
        }else {
            return candidateViewModel.candidats.filter{ candidat in
                candidat.lastName.lowercased().contains(search.lowercased()) ||
                candidat.firstName.lowercased().contains(search.lowercased())
                
            }
        }
    }
}


