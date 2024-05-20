//
//  Candidats.swift
//  Vitesse
//
//  Created by KEITA on 14/05/2024.
//

import SwiftUI

struct CandidatesListView: View {
    let candidateViewModel : CandidateViewModel
    let candidats = [RecruitTech(phone: candidateViewModel.fetchtoken().phone, note: candidateViewModel.fetchtoken().note, id: candidateViewModel.fetchtoken().id, firstName: candidateViewModel.fetchtoken().firstName, linkedinURL: candidateViewModel.fetchtoken().linkedinURL, isFavorite: candidateViewModel.fetchtoken().isFavorite, email: candidateViewModel.fetchtoken().email, lastName: candidateViewModel.fetchtoken().lastName)]
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
               
                
            }
        }
    }
}
