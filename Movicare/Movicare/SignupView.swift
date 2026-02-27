import SwiftUI
import SwiftData
import PhotosUI

struct SignupView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context

    @State private var fullName = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirm = ""
    @State private var phoneNumber = ""

    @State private var avatarUri: String? = nil
    @State private var validationMessage: String? = nil

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Spacer().frame(height: 32)

                headerView
                Spacer().frame(height: 8)

                formFieldsView
                Spacer().frame(height: 12)

                Group {
                    SecureField("Password", text: $password)
                        .padding(12)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))

                    Spacer().frame(height: 12)

                    SecureField("Confirm Password", text: $confirm)
                        .padding(12)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                }

                Spacer().frame(height: 24)

                if let validationMessage = validationMessage {
                    Text(validationMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.bottom, 8)
                }

                Button(action: {
                    Task {
                        guard !username.isEmpty, !password.isEmpty, !fullName.isEmpty, !email.isEmpty, !phoneNumber.isEmpty else {
                            validationMessage = "All fields are required"
                            return
                        }

                        guard password == confirm else {
                            validationMessage = "Passwords do not match"
                            return
                        }

                        guard email.contains("@") else {
                            validationMessage = "Invalid email format"
                            return
                        }

                        guard phoneNumber.allSatisfy({ $0.isNumber }) else {
                            validationMessage = "Phone number must contain only digits"
                            return
                        }

                        validationMessage = nil

                        let newUser = User(username: username, password: password, fullName: fullName, email: email, phoneNumber: phoneNumber)
                        do {
                            context.insert(newUser)
                            try context.save()
                            dismiss()
                        } catch {
                            validationMessage = "Failed to save user: \(error.localizedDescription)"
                        }
                    }
                }) {
                    Text("Sign Up")
                        .font(.system(size: 18, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color(hex: 0x1B75BC))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Spacer().frame(height: 20)

                HStack {
                    Text("Already have an account? ").foregroundColor(.gray).font(.system(size: 14))
                    Button(action: { dismiss() }) {
                        Text("Log In")
                            .font(.system(size: 14, weight: .bold))
                            .underline()
                    }
                }

                Spacer().frame(height: 32)
            }
            .padding(.horizontal, 32)
        }
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                }
            }
        }
    }

    private var formFieldsView: some View {
        Group {
            TextField("Full name", text: $fullName)
                .padding(12)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))

            Spacer().frame(height: 12)

            TextField("Username", text: $username)
                .padding(12)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))

            Spacer().frame(height: 12)

            TextField("Email", text: $email)
                .padding(12)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                .keyboardType(.emailAddress)

            Spacer().frame(height: 12)

            TextField("Phone Number", text: $phoneNumber)
                .padding(12)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                .keyboardType(.phonePad)
        }
    }

    private var headerView: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            } else {
                Image("profile")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            }
            
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text(selectedImage == nil ? "Choose photo" : "Change photo")
                    .foregroundColor(.blue)
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            selectedImage = uiImage
                        }
                    } else {
                        print("Failed to load image data")
                    }
                }
            }
        }
    }
}

#Preview {
    SignupView()
}
