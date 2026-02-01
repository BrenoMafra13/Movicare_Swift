import SwiftUI

struct FamilyMembersView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showAddDialog = false
    @State private var familyMembers: [String] = ["Dummy"]
    
    var body: some View {
        ZStack {
            VStack {
                if familyMembers.isEmpty {
                    Spacer()
                    Text("No family members added yet.")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 8) {
                            FamilyMemberListItem(name: "John Doe", relation: "Son", phone: "123-456-7890")
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
                AddFamilyMemberDialog(isShowing: $showAddDialog)
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
    }
}

struct FamilyMemberListItem: View {
    var name: String
    var relation: String
    var phone: String
    
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
            Image(systemName: "trash")
                .foregroundColor(.red)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 1, y: 1)
    }
}

struct AddFamilyMemberDialog: View {
    @Binding var isShowing: Bool
    @State private var name = ""
    @State private var relation = ""
    @State private var phone = ""
    
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
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5)))
                }
                
                HStack {
                    Spacer()
                    Button("Cancel") { isShowing = false }
                        .foregroundColor(.blue)
                        .padding(.trailing, 16)
                    
                    Button(action: { isShowing = false }) {
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
}
