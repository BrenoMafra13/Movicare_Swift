import SwiftUI
import SwiftData
import Contacts

struct FamilyMembersView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showAddDialog = false
    @State private var showContactsPermissionAlert = false
    let user: User

    private var sortedFamilyMembers: [FamilyMember] {
        user.familyMembers.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    var body: some View {
        ZStack {
            VStack {
                if sortedFamilyMembers.isEmpty {
                    Spacer()
                    Text("No family members added yet.")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(sortedFamilyMembers) { member in
                                FamilyMemberListItem(
                                    name: member.name,
                                    relation: member.relation,
                                    phone: member.phone,
                                    onRemove: { removeFamilyMember(member) }
                                )
                            }
                        }
                        .padding(16)
                    }
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { showAddDialog = true }) {
                        Image(systemName: "plus")
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(16)
                }
            }
            
            if showAddDialog {
                AddFamilyMemberDialog(isShowing: $showAddDialog) { name, relation, phone in
                    addFamilyMember(name: name, relation: relation, phone: phone)
                }
            }
        }
        .navigationTitle("Manage Family")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.primary)
                }
            }
        }
        .alert("Contacts Permission Needed", isPresented: $showContactsPermissionAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Allow Contacts access in Settings to save family members to your phone contacts.")
        }
    }

    private func addFamilyMember(name: String, relation: String, phone: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedRelation = relation.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty, !trimmedRelation.isEmpty, !trimmedPhone.isEmpty else {
            return
        }

        guard let normalizedPhone = normalizeE164Phone(trimmedPhone) else {
            return
        }

        let member = FamilyMember(
            name: trimmedName,
            relation: trimmedRelation,
            phone: normalizedPhone,
            user: user
        )
        user.familyMembers.append(member)
        modelContext.insert(member)
        try? modelContext.save()

        Task {
            await saveAsSystemContactIfPossible(name: trimmedName, relation: trimmedRelation, phone: normalizedPhone)
        }
    }

    private func normalizeE164Phone(_ value: String) -> String? {
        let compact = value
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")

        guard compact.hasPrefix("+") else {
            return nil
        }

        let digits = compact.dropFirst()
        guard !digits.isEmpty, digits.allSatisfy(\.isNumber) else {
            return nil
        }

        guard (8...15).contains(digits.count) else {
            return nil
        }

        return "+\(digits)"
    }

    private func removeFamilyMember(_ member: FamilyMember) {
        user.familyMembers.removeAll { $0.id == member.id }
        modelContext.delete(member)
        try? modelContext.save()
    }

    @MainActor
    private func saveAsSystemContactIfPossible(name: String, relation: String, phone: String) async {
        let contactStore = CNContactStore()
        let status = CNContactStore.authorizationStatus(for: .contacts)

        let hasAccess: Bool
        switch status {
        case .authorized:
            hasAccess = true
        case .notDetermined:
            hasAccess = await requestContactsAccess(contactStore)
        case .denied, .restricted:
            hasAccess = false
        @unknown default:
            hasAccess = false
        }

        guard hasAccess else {
            showContactsPermissionAlert = true
            return
        }

        let normalizedDigits = phone.filter(\.isNumber)
        let keys: [CNKeyDescriptor] = [CNContactPhoneNumbersKey as CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)

        var alreadyExists = false
        try? contactStore.enumerateContacts(with: request) { contact, stop in
            for existing in contact.phoneNumbers {
                let existingDigits = existing.value.stringValue.filter(\.isNumber)
                if !existingDigits.isEmpty, existingDigits == normalizedDigits {
                    alreadyExists = true
                    stop.pointee = true
                    break
                }
            }
        }

        if alreadyExists {
            return
        }

        let mutable = CNMutableContact()
        mutable.givenName = name
        mutable.familyName = relation
        mutable.phoneNumbers = [
            CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: phone))
        ]

        let saveRequest = CNSaveRequest()
        saveRequest.add(mutable, toContainerWithIdentifier: nil)
        try? contactStore.execute(saveRequest)
    }

    private func requestContactsAccess(_ store: CNContactStore) async -> Bool {
        await withCheckedContinuation { continuation in
            store.requestAccess(for: .contacts) { granted, _ in
                continuation.resume(returning: granted)
            }
        }
    }
}

struct FamilyMemberListItem: View {
    var name: String
    var relation: String
    var phone: String
    var onRemove: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(size: 18, weight: .bold))
                Text("\(relation) • \(phone)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: onRemove) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 1, y: 1)
    }
}

struct AddFamilyMemberDialog: View {
    @Binding var isShowing: Bool
    let onAdd: (String, String, String) -> Void
    @State private var name = ""
    @State private var relation = ""
    @State private var phone = ""
    @State private var validationMessage: String?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { isShowing = false }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Add Family Member").font(.headline)
                
                VStack(spacing: 12) {
                    TextField("Name", text: $name)
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5)))
                    
                    TextField("Relationship", text: $relation)
                        .padding(10)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5)))
                    
                    TextField("Phone Number", text: $phone)
                        .padding(10)
                        .keyboardType(.phonePad)
                        .textContentType(.telephoneNumber)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5)))
                }

                if let validationMessage {
                    Text(validationMessage)
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                }
                
                HStack {
                    Spacer()
                    Button("Cancel") { isShowing = false }
                        .foregroundColor(.blue)
                        .padding(.trailing, 16)
                    
                    Button(action: {
                        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        let trimmedRelation = relation.trimmingCharacters(in: .whitespacesAndNewlines)
                        let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)

                        guard !trimmedName.isEmpty, !trimmedRelation.isEmpty, !trimmedPhone.isEmpty else {
                            validationMessage = "Please fill in all fields."
                            return
                        }

                        guard let normalizedPhone = normalizeE164Phone(trimmedPhone) else {
                            validationMessage = "Invalid phone format. Use +<countrycode><number>, e.g. +14165551234"
                            return
                        }

                        validationMessage = nil
                        onAdd(trimmedName, trimmedRelation, normalizedPhone)
                        isShowing = false
                    }) {
                        Text("Add & Invite").fontWeight(.bold).foregroundColor(.blue)
                    }
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(12)
            .padding(40)
        }
    }

    private func normalizeE164Phone(_ value: String) -> String? {
        let compact = value
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")

        guard compact.hasPrefix("+") else {
            return nil
        }

        let digits = compact.dropFirst()
        guard !digits.isEmpty, digits.allSatisfy(\.isNumber) else {
            return nil
        }

        guard (8...15).contains(digits.count) else {
            return nil
        }

        return "+\(digits)"
    }
}
