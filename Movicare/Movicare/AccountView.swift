import SwiftUI
import SwiftData
import UIKit
import PhotosUI

struct AccountView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    let user: User
    @State private var street: String = ""
    @State private var unit: String = ""
    @State private var postalCode: String = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                Group {
                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                    } else if let avatarData = user.avatarData, let uiImage = UIImage(data: avatarData) {
                        Image(uiImage: uiImage)
                            .resizable()
                    } else {
                        Image("profile")
                            .resizable()
                    }
                }
                .frame(width: 170, height: 170)
                .clipShape(Circle())
                .padding(.vertical, 24)

                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Text("Change photo")
                        .foregroundColor(.blue)
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            await MainActor.run {
                                selectedImage = uiImage
                            }
                        }
                    }
                }
                .padding(.bottom, 16)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Street:").font(.system(size: 18, weight: .bold))
                    TextField("", text: $street)
                        .padding(12)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        .padding(.bottom, 8)
                    
                    Text("Unit:").font(.system(size: 18, weight: .bold))
                    TextField("", text: $unit)
                        .padding(12)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        .padding(.bottom, 8)
                    
                    Text("Postal Code:").font(.system(size: 18, weight: .bold))
                    TextField("", text: $postalCode)
                        .padding(12)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 28)
                
                HStack(spacing: 16) {
                    Button(action: { dismiss() }) {
                        Text("BACK")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color(hex: 0xF44336))
                            .cornerRadius(4)
                    }
                    
                    Button(action: saveAndDismiss) {
                        Text("SAVE")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color(hex: 0x1565C0))
                            .cornerRadius(4)
                    }
                }
            }
            .padding(24)
        }
        .navigationTitle("Edit account")
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
        .onAppear(perform: loadAddress)
    }

    private func loadAddress() {
        let rawAddress = user.address.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !rawAddress.isEmpty, rawAddress != "Not added yet" else {
            street = ""
            unit = ""
            postalCode = ""
            return
        }

        let parts = rawAddress.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        street = parts.indices.contains(0) ? parts[0] : ""
        unit = parts.indices.contains(1) ? parts[1] : ""
        postalCode = parts.indices.contains(2) ? parts[2] : ""
    }

    private func saveAndDismiss() {
        let formattedStreet = street.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedUnit = unit.trimmingCharacters(in: .whitespacesAndNewlines)
        let formattedPostal = postalCode.trimmingCharacters(in: .whitespacesAndNewlines)

        let chunks = [formattedStreet, formattedUnit, formattedPostal].filter { !$0.isEmpty }
        user.address = chunks.isEmpty ? "Not added yet" : chunks.joined(separator: ", ")

        if let selectedImage {
            user.avatarData = selectedImage.jpegData(compressionQuality: 0.8)
        }

        do {
            try context.save()
        } catch {
        }

        dismiss()
    }
}


