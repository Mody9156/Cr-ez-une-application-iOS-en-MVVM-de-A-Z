//
//  Candidats.swift
//  Vitesse
//
//  Created by KEITA on 14/05/2024.
//

import SwiftUI

struct Candidats: View {
    var body: some View {
     
            ZStack {
                Color.blue.opacity(0.5).ignoresSafeArea()
                VStack{
                    HStack {
                        Button("Cancel") {
                            
                        }.frame(width: 100,height: 50)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                        Text("Candidats")  .font(.largeTitle)
                            .fontWeight(.bold)
                        .foregroundColor(.blue).padding()
                        
                        Button("Delete") {
                            <#code#>
                        }.frame(width: 100,height: 50)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                
            }
        }
    }
}

