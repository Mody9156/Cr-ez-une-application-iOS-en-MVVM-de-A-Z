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
        NavigationView {
            List {
                ForEach(filteredCandidates, id: \.id) { candidate in
                    VStack(alignment: .leading) {
                        Text(candidate.firstName)
                        Text(candidate.lastName)
                    }
                }
               
            }
            .toolbar {
                EditButton()
            }
            .searchable(text: $search)
            .navigationTitle("Candidats")
        }
    }

    var filteredCandidates: [RecruitTech] {
        if search.isEmpty {
            return candidateViewModel.candidats
        } else {
            return candidateViewModel.candidats.filter {
                $0.lastName.lowercased().contains(search.lowercased()) ||
                $0.firstName.lowercased().contains(search.lowercased())
            }
        }
    }
}
