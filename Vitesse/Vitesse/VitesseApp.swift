import SwiftUI

@main
struct VitesseApp: App {
    @StateObject var vitesseViewModel = VitesseViewModel()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if vitesseViewModel.onLoginSucceed {
                    TabView {
                        CandidatesListView(
                            candidateListViewModel: vitesseViewModel.candidateListViewModel,
                            candidateDetailsManagerViewModel: vitesseViewModel.candidateDetailsManager)
                    }
                    .onAppear {
                        // Créer un nouveau candidat
                        // Exemple : vitesseViewModel.createNewCandidate()
                    }
                } else {
                    LoginView(
                        loginViewModel: vitesseViewModel.loginViewModel,
                        vitesseViewModel: VitesseViewModel())
                }
            }
        }
    }
}
