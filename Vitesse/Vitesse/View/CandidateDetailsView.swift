import SwiftUI

struct CandidateDetailView: View {
    @ObservedObject var candidateDetailsManager: CandidateDetailsManager
    @State private var isEditing = false
    @State private var editedNote: String = ""
    @State private var editedFirstName: String = ""
    @State private var editedLastName: String = ""
    @State private var editedPhone: String?
    @State private var editedEmail: String = ""
    @State private var editedLinkedIn: String?
    
    var candidate: CandidateInformation
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    if isEditing {
                        TextField("Last Name", text: $editedLastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("First Name", text: $editedFirstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        Text(candidate.lastName)
                            .font(.title2)
                        Text(candidate.firstName)
                            .font(.title2)
                    }
                    Spacer()
                    Image(systemName: "star")
                        .foregroundColor(.yellow)
                        .font(.title2)
                }
                
                HStack {
                    Text("Phone")
                    if isEditing {
                        TextField("Phone", text: Binding(
                            get: { editedPhone ?? "" },
                            set: { editedPhone = $0 }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        if let phone = candidate.phone {
                            Text(phone)
                        } else {
                            Text("No phone available")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                HStack {
                    Text("Email")
                    if isEditing {
                        TextField("Email", text: $editedEmail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        Text(candidate.email)
                    }
                }
                
                HStack {
                    Text("LinkedIn")
                    if isEditing {
                        TextField("LinkedIn URL", text: Binding(
                            get: { editedLinkedIn ?? "" },
                            set: { editedLinkedIn = $0 }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        if let linkedIn = candidate.linkedinURL {
                            Text(linkedIn)
                        } else {
                            Text("Go on LinkedIn")
                                .foregroundColor(.white)
                        }
                    }
                }
                
                Text("Note")
                if isEditing {
                    TextField("Note", text: $editedNote)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    if let note = candidate.note {
                        Text(note)
                    } else {
                        Text("No note available")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            Task {
                await loadCandidateProfile()
            }
            initializeEditingFields()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    Button("Save") {
                        Task {
                            await saveCandidate()
                        }
                    }
                } else {
                    Button("Edit") {
                        isEditing.toggle()
                    }
                }
            }
        }
    }
}

extension CandidateDetailView {
    func loadCandidateProfile() async {
        do {
            let candidateDetails = try await candidateDetailsManager.displayCandidateDetails()
            await MainActor.run {
                candidateDetailsManager.candidats = candidateDetails
                print("candidateDetails: \(candidateDetails)")
                print("Félicitations, loadCandidateProfile est passée")
            }
        } catch {
            print("Dommage, le candidat n'est pas passé")
        }
    }
    
    func saveCandidate() async {
        do {
            let updatedCandidate = try await candidateDetailsManager.candidateUpdater(
                phone: editedPhone,
                note: editedNote,
                firstName: editedFirstName,
                linkedinURL: editedLinkedIn,
                isFavorite: candidate.isFavorite,
                email: editedEmail,
                lastName: editedLastName,
                id: candidate.id
            )
            await MainActor.run {
                candidateDetailsManager.updateCandidateInformation(with: updatedCandidate)
                isEditing.toggle()
                print("Félicitations Updater \(updatedCandidate)")
            }
        } catch {
            print("Dommage, le Updater n'est pas passé")
        }
    }
}

extension CandidateDetailView {
    func initializeEditingFields() {
        editedNote = candidate.note ?? ""
        editedFirstName = candidate.firstName
        editedLastName = candidate.lastName
        editedPhone = candidate.phone ?? ""
        editedEmail = candidate.email
        editedLinkedIn = candidate.linkedinURL ?? ""
    }
}
