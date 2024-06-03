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
        VStack (alignment: .leading) {
            Section {
                HStack {
                    if isEditing {
                        TextField("First Name", text: $editedFirstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Last Name", text: $editedLastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        Text(CandidateInformation.firstName)
                            .font(.title2)
                        Text(CandidateInformation.lastName)
                            .font(.title2)
                    }
                    Spacer()
                    if CandidateInformation.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.title2)
                    }
                }
                .padding()

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
                .padding()

                HStack {
                    Text("Email")
                    if isEditing {
                        TextField("Email", text: $editedEmail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        Text(CandidateInformation.email)
                    }
                }
                .padding()

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
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("Note")
                    if isEditing {
                        TextField("Note", text: $editedNote)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        if let note = CandidateInformation.note {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.orange, lineWidth: 1)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                                    .frame(height: 100)
                                Text(note)
                                    .padding()
                                    .foregroundColor(.black)
                            }
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
        .onAppear {
            Task {
                print("Nombre de candidats : \(CandidateInformation)")
                print("loadCandidateProfile():\(await loadCandidateProfile())")
                await loadCandidateProfile()
                initialiseEditingFields()

            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    Button("Done") {
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
