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
    @State var test : Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.opacity(0.5).ignoresSafeArea()
                VStack {
                   
                    VStack {
                        List {
                            ForEach(searchResult, id: \.id) { element in
                                NavigationLink(destination: CandidateDetailsView(candidateViewModel: CandidateViewModel(candidateProfile: CandidateProfile(), candidateDelete: CandidateDelete(), candidateIDFetcher: CandidateIDFetcher(), candidateFavoritesManager: CandidateFavoritesManager()))){
                                    HStack {
                                        Text(element.lastName)
                                        Text(element.firstName)
                                        Spacer()
                                        Image(systemName: "star.fill").backgroundStyle(element.isFavorite ? .yellow : .blue)
                                    }
                                }
                                
                            }
                            .onDelete(perform: candidateViewModel.deleteCandidate)
                        }.toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                   
                                        EditButton().frame(width: 100, height: 50)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    
                                    
                                }
                            
                        }.toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    Task{@MainActor in
                                       candidateViewModel.processCandidateElements

                                    }
                                } label: {
                                    Image(systemName: "star.fill")
                                }
                                .frame(width: 100, height: 50)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .searchable(text: $search)
                                
                                
                            }
                        
                    }.toolbar {
                        ToolbarItem(placement: .navigation) {
                            
                               Text("Candidats")
                                   .font(.title3)
                                   .fontWeight(.bold)
                                   .foregroundColor(.blue)
                                   .padding()
                            
                            
                        }
                    
                }
                       
                       
                    }
                }
            }
            .searchable(text: $search)
            .listStyle(.plain)
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden, edges: .bottom)
        }
    }

    var searchResult: [RecruitTech] {
        if search.isEmpty {
            return candidateViewModel.candidats
        } else {
            return candidateViewModel.candidats.filter { candidat in
                candidat.lastName.lowercased().contains(search.lowercased()) ||
                candidat.firstName.lowercased().contains(search.lowercased())
            }
        }
    }
}
