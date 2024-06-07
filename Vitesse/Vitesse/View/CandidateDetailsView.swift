import SwiftUI

struct CandidateDetailView: View {
    @StateObject var candidateDetailsManagerViewModel: CandidateDetailsManagerViewModel
    @State private var isEditing = false
    @State private var editedNote: String?
    @State private var editedFirstName: String = ""
    @State private var editedLastName: String = ""
    @State private var editedPhone: String?
    @State private var editedEmail: String = ""
    @State private var editedLinkedIn: String?
    @State var candidateInformation: CandidateInformation
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var candidateListViewModel: CandidateListViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Section {
                HStack {
                    if isEditing {
                        TextFieldManager(textField: "First Name", text: $editedFirstName)
                        TextFieldManager(textField: "Last Name", text: $editedLastName)
                        Spacer()
                        
                        Button {
                            Task {
                                if candidateInformation.isFavorite {
                                    try await candidateListViewModel.removeCandidateFromFavorites(selectedCandidateId: candidateInformation.id)
                                } else {
                                    try await candidateListViewModel.addCandidateToFavorites(selectedCandidateId: candidateInformation.id)
                                }
                            }
                        } label: {
                            Text(candidateInformation.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                    } else {
                        Text(candidateInformation.firstName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(candidateInformation.lastName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    Spacer()
                    if candidateInformation.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.title2)
                    }
                    
                }
                .padding()

                HStack {
                    Text("Phone :")
                    if isEditing {
                        TextField("Phone", text: Binding(
                            get: { editedPhone ?? "" },
                            set: { editedPhone = $0 }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        if let phone = candidateInformation.phone {
                            Text(phone)
                        } else {
                            Text("No phone available")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()

                HStack {
                    Text("Email :")
                    if isEditing {
                        TextFieldManager(textField: "Email", text: $editedEmail)
                    } else {
                        Text(candidateInformation.email)
                    }
                }
                .padding()

                HStack {
                    Text("LinkedIn :")
                    if isEditing {
                        TextField("LinkedIn URL", text: Binding(
                            get: { editedLinkedIn ?? "" },
                            set: { editedLinkedIn = $0 }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        if let linkedIn = candidateInformation.linkedinURL,
                           let url = URL(string: linkedIn) {
                            Link("Go on LinkedIn", destination: url)
                                .padding().border(.orange)
                                .foregroundColor(.white)
                                .background(Color.orange)
                                .cornerRadius(10)
                        } else {
                            Text("No LinkedIn available")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("Note :")
                    if isEditing {
                        TextField("Note", text: Binding(get: { editedNote ?? "" }, set: { editedNote = $0 }))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        if let note = candidateInformation.note {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.orange, lineWidth: 1)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                                .frame(height: 100)
                                .overlay(
                                    Text(note)
                                        .padding()
                                        .foregroundColor(.black),
                                    alignment: .center
                                )
                        } else {
                            Text("No note available")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
            }
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .task {
            initialiseEditingFields()
            await loadCandidateProfile()
        }
        .toolbar {
            toolbarContent
        }
    }
    
    // Toolbar content
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if isEditing {
                Button("Cancel") {
                    isEditing = false
                }
                .foregroundColor(.orange)
            } else {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left.circle")
                        .foregroundColor(.orange)
                }
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            if isEditing {
                Button("Done") {
                    Task {
                        await saveCandidate()
                    }
                }
                .foregroundColor(.orange)
            } else {
                Button("Edit") {
                    isEditing.toggle()
                }
                .foregroundColor(.orange)
            }
        }
    }
}

struct TextFieldManager: View {
    var textField: String = ""
    @Binding var text: String
    
    var body: some View {
        TextField(textField, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

extension CandidateDetailView {
    func loadCandidateProfile() async {
        do {
            let loadCandidate = try await candidateDetailsManagerViewModel.displayCandidateDetails(selectedCandidateId: candidateInformation.id)
            print("Félicitations, \(loadCandidate) est passée")
        } catch {
            print("\(candidateInformation.email)")
            print("Dommage, le candidat n'est pas passé")
        }
    }

    func saveCandidate() async {
        do {
            let updatedCandidate = try await candidateDetailsManager
