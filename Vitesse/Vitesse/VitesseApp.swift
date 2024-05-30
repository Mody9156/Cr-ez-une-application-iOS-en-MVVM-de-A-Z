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
                        
                    }.onAppear{
                        //créer un nouveau candidat
                    }
                    
                } else {
                    LoginView(loginViewModel: vitesseViewModel.loginViewModel, vitesseViewModel: VitesseViewModel())
                }
            }.animation(.easeInOut(duration: 0.1), value: UUID())
        }
    }
}
