import SwiftUI

struct CandidateDetailView: View {
    @ObservedObject var CandidateDetailsManagerViewModel: CandidateDetailsManagerViewModel
    @State private var isEditing = false
    @State private var editedNote: String = ""
    @State private var editedFirstName: String = ""
    @State private var editedLastName: String = ""
    @State private var editedPhone: String?
    @State private var editedEmail: String = ""
    @State private var editedLinkedIn: String?
    @State var CandidateInformation: CandidateInformation

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
                        Text(CandidateInformation.lastName)
                            .font(.title2)
                        Text(CandidateInformation.firstName)
                            .font(.title2)
                    }
                    Spacer()
                    Image(systemName: CandidateInformation.isFavorite ? "star.fill":"")
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
                        if let phone = CandidateInformation.phone {
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
                        Text(CandidateInformation.email)
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
                        if let linkedIn = CandidateInformation.linkedinURL {
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
                    if let note = CandidateInformation.note {
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
                print("Nombre de candidats : \(CandidateInformation)")
                print("loadCandidateProfile():\(await loadCandidateProfile())")
                await loadCandidateProfile()
            }
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
            let candidateDetails = try await CandidateDetailsManagerViewModel.displayCandidateDetails()
            CandidateInformation = candidateDetails
            initialiseEditingFields()
            print("candidateDetails: \(candidateDetails)")
            print("Félicitations, loadCandidateProfile est passée")
               CandidateInformation = candidateDetails
                initialiseEditingFields()
                print("candidateDetails: \(candidateDetails)")
                print("Félicitations, loadCandidateProfile est passée")
        } catch {
            print("Dommage, le candidat n'est pas passé")
        }
    }

    func saveCandidate() async {
        do {
            let updatedCandidate = try await CandidateDetailsManagerViewModel.candidateUpdater(
                phone: editedPhone,
                note: editedNote,
                firstName: editedFirstName,
                linkedinURL: editedLinkedIn,
                isFavorite: CandidateInformation.isFavorite,
                email: editedEmail,
                lastName: editedLastName,
                id: CandidateInformation.id
            )
            await MainActor.run {
                CandidateDetailsManagerViewModel.updateCandidateInformation(with: updatedCandidate)
                isEditing.toggle()
                print("Félicitations Updater \(updatedCandidate)")
            }
        } catch {
            print("Dommage, le Updater n'est pas passé")
        }
    }
}

extension CandidateDetailView {
    func initialiseEditingFields() {
        editedNote = CandidateInformation.note ?? ""
        editedFirstName = CandidateInformation.firstName
        editedLastName = CandidateInformation.lastName
        editedPhone = CandidateInformation.phone ?? ""
        editedEmail = CandidateInformation.email
        editedLinkedIn = CandidateInformation.linkedinURL ?? ""
    }
}
