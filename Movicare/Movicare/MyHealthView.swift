import SwiftUI

struct MyHealthView: View {
    @Environment(\.dismiss) var dismiss
    @State private var userName: String = "User Name"
    @State private var userRole: String = "Patient"
    @State private var conditions: String = "Asthma\nHypertension"
    @State private var allergies: String = "Peanuts\nPenicillin"
    @State private var height: String = "180"
    @State private var weight: String = "75"
    @State private var isEditing: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 16) {
                    Image("profile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(userName)
                            .font(.system(size: 24, weight: .bold))
                        Text(userRole)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 8)
                
                HealthSection(title: "Medical Conditions", content: $conditions, isEditing: isEditing)
                
                HealthSection(title: "Allergies", content: $allergies, isEditing: isEditing)
                
                HStack(spacing: 16) {
                    HealthCard(title: "Height", value: $height, unit: "cm", isEditing: isEditing)
                    HealthCard(title: "Weight", value: $weight, unit: "kg", isEditing: isEditing)
                }
            }
            .padding(16)
        }
        .navigationTitle("My Health")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.primary)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isEditing.toggle() }) {
                    IconView(isEditing: isEditing)
                }
            }
        }
    }
}

struct HealthSection: View {
    let title: String
    @Binding var content: String
    var isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
            
            VStack(alignment: .leading) {
                if isEditing {
                    TextEditor(text: $content)
                        .frame(minHeight: 100)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                } else {
                    VStack(alignment: .leading, spacing: 6) {
                        if content.trimmed().isEmpty {
                            Text("None listed").foregroundColor(.gray)
                        } else {
                            ForEach(content.components(separatedBy: "\n"), id: \.self) { item in
                                if !item.isEmpty {
                                    HStack(alignment: .top) {
                                        Text("•").foregroundColor(Color(hex: 0x4CAF50))
                                        Text(item)
                                    }
                                }
                            }
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 2)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                }
            }
        }
    }
}

struct HealthCard: View {
    let title: String
    @Binding var value: String
    let unit: String
    var isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
            
            VStack {
                if isEditing {
                    TextField(unit, text: $value)
                        .keyboardType(.decimalPad)
                        .padding(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                } else {
                    Text(value.isEmpty ? "-- \(unit)" : "\(value) \(unit)")
                        .font(.system(size: 20, weight: .bold))
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 2)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct IconView: View {
    var isEditing: Bool
    var body: some View {
        Image(systemName: isEditing ? "checkmark.circle.fill" : "pencil")
            .font(.system(size: 18))
    }
}

extension String {
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
