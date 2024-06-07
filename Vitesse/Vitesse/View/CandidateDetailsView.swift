import SwiftUI

struct CandidateDetailView: View {
    @StateObject var candidateDetailsManagerViewModel: CandidateDetailsManagerViewModel
    @StateObject var candidateListViewModel: CandidateListViewModel
    @State private var isEditing = false
    @State private var editedNote: String?
    @State private var editedFirstName: String = ""
    @State private var editedLastName: String = ""
    @State private var editedPhone: String?
    @State private var editedEmail: String = ""
    @State private var editedLinkedIn: String?
    @State var candidateInformation: CandidateInformation
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isButtonVisible = true

    var body: some View {
        VStack(alignment: .leading) {
            Section {
                HStack {
                    if isEditing {
                        TextFieldManager(textField: "First Name", text: $editedFirstName)
                        TextFieldManager(textField: "Last Name", text: $editedLastName)
                        Spacer()

                        if isButtonVisible {
                            Button {
                                Task {
                                    try await candidateListViewModel.showFavoriteCandidates(selectedCandidateId: candidateInformation.id)
                                    withAnimation {
                                        isButtonVisible = false
                                    }
                                }
                            } label: {
                                Text(candidateInformation.isFavorite ? "Remove from favorites" : "Add to favorites")
                                    .foregroundColor(.orange)
                                    .padding()
                                    .background(Color.orange.opacity(0.2))
                                    .cornerRadius(10)
                            }
                            .transition(.opacity)
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
                    Text("Phone:")
                    if isEditing {
                        TextFieldManager(textField: "Phone", text: Binding(
                            get: { editedPhone ?? "" },
                            set: { editedPhone = $0 }
                        ))
                        
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
                    Text("Email:")
                    if isEditing {
                        TextFieldManager(textField: "Email", text: $editedEmail)
                    } else {
                        Text(candidateInformation.email)
                    }
                }
                .padding()

                HStack {
                    Text("LinkedIn:")
                    if isEditing {
                        TextFieldManager(textField: "LinkedIn URL", text: Binding(
                            get: { editedLinkedIn ?? "" },
                            set: { editedLinkedIn = $0 }
                        ))
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
                    Text("Note:")
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
            print("Success, \(loadCandidate) has been loaded")
        } catch {
            print("Error loading candidate profile for \(candidateInformation.email)")
        }
    }

    func saveCandidate() async {
        do {
            let updatedCandidate = try await candidateDetailsManagerViewModel.candidateUpdater(
                phone: editedPhone,
                note: editedNote,
                firstName: editedFirstName,
                linkedinURL: editedLinkedIn,
                isFavorite: candidateInformation.isFavorite,
                email: editedEmail,
                lastName: editedLastName,
                id: candidateInformation.id
            )
            candidateDetailsManagerViewModel.updateCandidateInformation(with: updatedCandidate)
            isEditing.toggle()
            print("isEditing: \(isEditing)")
            print("Success: Candidate updated \(updatedCandidate)")
        } catch {
            print("Error updating candidate")
        }
    }

    func initialiseEditingFields() {
        editedNote = candidateInformation.note ?? ""
        editedFirstName = candidateInformation.firstName
        editedLastName = candidateInformation.lastName
        editedPhone = candidateInformation.phone ?? ""
        editedEmail = candidateInformation.email
        editedLinkedIn = candidateInformation.linkedinURL ?? ""
    }
}
