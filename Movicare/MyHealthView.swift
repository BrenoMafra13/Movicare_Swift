import SwiftUI
import SwiftData
import UIKit

struct MyHealthView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context

    let user: User
    @State private var isEditing = false
    @State private var conditions = ""
    @State private var allergies = ""
    @State private var height = ""
    @State private var weight = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 16) {
                    if let avatarData = user.avatarData, let uiImage = UIImage(data: avatarData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else {
                        Image("profile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    }

                    VStack(alignment: .leading) {
                        Text(user.fullName)
                            .font(.system(size: 24, weight: .bold))
                        Text("Senior")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Button(isEditing ? "Save" : "Edit") {
                        if isEditing {
                            save()
                        } else {
                            isEditing = true
                        }
                    }
                }

                HealthSection(title: "Medical Conditions", text: $conditions, isEditing: isEditing)
                HealthSection(title: "Allergies", text: $allergies, isEditing: isEditing)

                HStack(spacing: 16) {
                    HealthCard(title: "Height", value: $height, unit: "cm", isEditing: isEditing)
                    HealthCard(title: "Weight", value: $weight, unit: "kg", isEditing: isEditing)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .navigationTitle("My Health")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadFromUser)
    }

    private func loadFromUser() {
        conditions = user.conditions ?? ""
        allergies = user.allergies ?? ""
        height = user.height ?? ""
        weight = user.weight ?? ""
    }

    private func save() {
        user.conditions = conditions.trimmingCharacters(in: .whitespacesAndNewlines)
        user.allergies = allergies.trimmingCharacters(in: .whitespacesAndNewlines)
        user.height = height.trimmingCharacters(in: .whitespacesAndNewlines)
        user.weight = weight.trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            try context.save()
            isEditing = false
        } catch {
            isEditing = false
        }
    }
}

private struct HealthSection: View {
    let title: String
    @Binding var text: String
    let isEditing: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))

            if isEditing {
                TextField(title, text: $text)
                    .textFieldStyle(.roundedBorder)
            } else {
                Text(text.isEmpty ? "--" : text)
                    .font(.system(size: 16))
            }
        }
    }
}

private struct HealthCard: View {
    let title: String
    @Binding var value: String
    let unit: String
    let isEditing: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))

            if isEditing {
                TextField(title, text: $value)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
            } else {
                Text(value.isEmpty ? "--" : "\(value) \(unit)")
                    .font(.system(size: 16))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

