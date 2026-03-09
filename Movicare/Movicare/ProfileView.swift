import SwiftUI
import SwiftData
import UIKit

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    let user: User
    @Binding var isLoggedIn: Bool
    @Binding var currentUsername: String
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 16) {
                    if let avatarData = user.avatarData, let uiImage = UIImage(data: avatarData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 130, height: 130)
                            .clipShape(Circle())
                    } else {
                        Image("profile")
                            .resizable()
                            .frame(width: 130, height: 130)
                            .clipShape(Circle())
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(user.fullName)
                            .font(.system(size: 30, weight: .bold))
                        Text("SENIOR")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                        
                        Spacer().frame(height: 10)
                        Text("My Address:")
                            .font(.system(size: 20, weight: .bold))
                        
                        Spacer().frame(height: 4)
                        Text(user.address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Not added yet" : user.address)
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 28)
                
                VStack(spacing: 10) {
                    NavigationLink(destination: MyHealthView(user: user)) {
                        ProfileMenuItem(title: "My Health")
                    }
                    NavigationLink(destination: MedicationsView()) {
                        ProfileMenuItem(title: "Medications")
                    }
                    NavigationLink(destination: FamilyMembersView()) {
                        ProfileMenuItem(title: "Family Members")
                    }
                    NavigationLink(destination: AppointmentsView()) {
                        ProfileMenuItem(title: "Appointments")
                    }
                    NavigationLink(destination: AccountView(user: user)) {
                        ProfileMenuItem(title: "Account")
                    }
                }
            }
            
            Spacer()
            
            VStack(spacing: 10) {
                Button(action: { dismiss() }) {
                    Text("Back")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color(hex: 0x1E88E5))
                        .cornerRadius(4)
                        .shadow(radius: 3, y: 3)
                }
                
                Button(action: {
                    currentUsername = ""
                    isLoggedIn = false
                }) {
                    Text("Log out")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: 0xE3F2FD))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color(hex: 0xF44336))
                        .cornerRadius(4)
                        .shadow(radius: 3, y: 3)
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 8)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .navigationBarBackButtonHidden(true)
    }
}

struct ProfileMenuItem: View {
    var title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18))
                .foregroundColor(.black)
            Spacer()
            Image(systemName: "arrow.right")
                .foregroundColor(.black)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Color(hex: 0xF7F7F7))
        .cornerRadius(8)
    }
}

#Preview {
    ProfileView(
        user: User(username: "preview", password: "123", fullName: "Preview User", email: "preview@email.com", phoneNumber: "0000000000"),
        isLoggedIn: .constant(true),
        currentUsername: .constant("preview")
    )
}
