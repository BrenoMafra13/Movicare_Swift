import SwiftUI

struct SignupView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var fullName = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirm = ""
    @State private var phoneNumber = ""
    
    @State private var role = "senior"
    private let roles = ["senior", "family", "caregiver", "volunteer"]
    
    @State private var specialty = ""
    @State private var licenseNumber = ""
    @State private var idDocumentUri: String? = nil
    @State private var selfieUri: String? = nil
    @State private var certificationUri: String? = nil
    @State private var avatarUri: String? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Spacer().frame(height: 32)
                
                VStack {
                    if avatarUri == nil {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                    } else {
                        Image("profile")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    }
                    
                    Button(action: { }) {
                        Text(avatarUri == nil ? "Choose photo" : "Change photo")
                    }
                }
                
                Spacer().frame(height: 8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Role").font(.caption).foregroundColor(.gray)
                    Picker("Role", selection: $role) {
                        ForEach(roles, id: \.self) { roleName in
                            Text(roleName.capitalized).tag(roleName)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                }
                
                Spacer().frame(height: 12)
                
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
                    
                    Spacer().frame(height: 12)
                }
                
                if role == "caregiver" {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Caregiver Details").font(.headline)
                        
                        TextField("Specialty (e.g. Nurse)", text: $specialty)
                            .padding(12)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                        
                        TextField("Professional License #", text: $licenseNumber)
                            .padding(12)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                        
                        Text("Verification Documents").font(.subheadline).fontWeight(.semibold)
                        Text("Required: ID, Selfie, Certificate").font(.caption).foregroundColor(.gray)
                        
                        Button(action: { idDocumentUri = "mock" }) {
                            Text(idDocumentUri != nil ? "ID Uploaded ✓" : "Upload Gov ID")
                                .frame(maxWidth: .infinity).padding().background(Color.blue.opacity(0.1)).cornerRadius(8)
                        }
                        
                        Button(action: { selfieUri = "mock" }) {
                            Text(selfieUri != nil ? "Selfie Uploaded ✓" : "Upload Selfie")
                                .frame(maxWidth: .infinity).padding().background(Color.blue.opacity(0.1)).cornerRadius(8)
                        }
                        
                        Button(action: { certificationUri = "mock" }) {
                            Text(certificationUri != nil ? "Certificate Uploaded ✓" : "Upload Certificate")
                                .frame(maxWidth: .infinity).padding().background(Color.blue.opacity(0.1)).cornerRadius(8)
                        }
                    }
                    Spacer().frame(height: 12)
                }
                
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
                
                Button(action: { dismiss() }) {
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
}

#Preview {
    SignupView()
}
