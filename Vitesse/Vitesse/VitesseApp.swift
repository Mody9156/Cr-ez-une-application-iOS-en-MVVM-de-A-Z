import SwiftUI

@main
struct VitesseApp: App {
    @StateObject var vitesseViewModel = VitesseViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group{
                if vitesseViewModel.onLoginSucceed {
                    TabView {
                        CandidatesListView(
                            candidateListViewModel: vitesseViewModel.candidateListViewModel)
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("Candidats")
                        }
                    }.onAppear{
                        //créer un nouveau candidat
                    }
                    
                } else {
                    LoginView(loginViewModel: vitesseViewModel.loginViewModel, vitesseViewModel: VitesseViewModel())
                }
            }.animation(.easeInOut(duration: 1.5), value: UUID())
        }
    }
}
