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
                    HStack {
                        
                        Button {
                            test = true
                        } label: {
                            Text("Edit")
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
                            // Logique pour le bouton étoile
                        } label: {
                            Image(systemName: "star.fill")
                        }
                        .frame(width: 100, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    Spacer()
                    VStack {
                        List {
                            ForEach(searchResult, id: \.id) { element in
                                NavigationLink(destination: CandidateDetailsView(candidateViewModel: CandidateViewModel(candidateProfile: CandidateProfile(), candidateDelete: CandidateDelete(), candidateIDFetcher: CandidateIDFetcher()))){
                                    HStack {
                                        Text(element.lastName)
                                        Text(element.firstName)
                                        Spacer()
                                        Image(systemName: "star.fill").foregroundColor(element.isFavorite ? .yellow : .black)
                                    }
                                }
                                
                            }
                            .onDelete(perform: candidateViewModel.deleteCandidate)
                        }
                        .toolbar {
                            if test{
                                EditButton()
                            }
                        }
                        .searchable(text: $search)
                       
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
