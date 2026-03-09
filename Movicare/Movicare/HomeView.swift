import SwiftUI
import SwiftData

struct HomeView: View {
    @Binding var isLoggedIn: Bool
    @Binding var currentUsername: String
    @Environment(\.modelContext) private var modelContext
    @State private var user: User?
    
    var body: some View {
        Group {
            if let user {
                SeniorDashboard(user: user, isLoggedIn: $isLoggedIn, currentUsername: $currentUsername)
            } else {
                ContentUnavailableView("User not found", systemImage: "person.slash")
            }
        }
        .onAppear(perform: loadCurrentUser)
    }

    private func loadCurrentUser() {
        guard !currentUsername.isEmpty else {
            isLoggedIn = false
            return
        }

        let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.username == currentUsername })
        user = try? modelContext.fetch(descriptor).first

        if user == nil {
            isLoggedIn = false
            currentUsername = ""
        }
    }
}

struct SeniorDashboard: View {
    let user: User
    @Binding var isLoggedIn: Bool
    @Binding var currentUsername: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 12) {
                    NavigationLink(destination: ProfileView(user: user, isLoggedIn: $isLoggedIn, currentUsername: $currentUsername)) {
                        if let avatarData = user.avatarData, let uiImage = UIImage(data: avatarData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 75, height: 75)
                                .clipShape(Circle())
                        } else {
                            Image("profile")
                                .resizable()
                                .frame(width: 75, height: 75)
                                .clipShape(Circle())
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    VStack(alignment: .leading) {
                        Text(user.fullName)
                            .font(.system(size: 30, weight: .bold))
                        Text("SENIOR")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                }
                
                VStack {
                    VStack {
                        Text("I'm OK")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer().frame(height: 8)
                        
                        HStack {
                            Image(systemName: "bell.fill")
                            Text("Panic button\nhold 3 sec")
                                .font(.system(size: 20))
                                .lineLimit(2)
                        }
                        .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .background(Color(hex: 0x4CAF50))
                    .cornerRadius(20)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("MEDICATIONS DUE")
                        .font(.system(size: 20, weight: .bold))
                    
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Medication Name")
                                    .font(.system(size: 18, weight: .medium))
                                Text("Dosage • Time")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            HStack(spacing: 8) {
                                Button(action: {}) {
                                    Text("TAKE")
                                        .font(.system(size: 12))
                                        .frame(height: 36)
                                        .padding(.horizontal, 8)
                                        .background(Color(hex: 0x1565C0))
                                        .foregroundColor(.white)
                                        .cornerRadius(4)
                                }
                                
                                Button(action: {}) {
                                    Text("SNOOZE")
                                        .font(.system(size: 12))
                                        .frame(height: 36)
                                        .padding(.horizontal, 8)
                                        .background(Color(hex: 0xD32F2F))
                                        .foregroundColor(.white)
                                        .cornerRadius(4)
                                }
                            }
                        }
                        Divider()
                    }
                }
                .padding(16)
                .background(Color(hex: 0xF8F8F8))
                .cornerRadius(14)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Help Request")
                        .font(.system(size: 20, weight: .bold))
                    
                    HStack(spacing: 16) {
                        VStack {
                            Image(systemName: "mappin.and.ellipse")
.font(.system(size: 50))
                            Text("Ride")
                                .font(.system(size: 25, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
.frame(height: 130)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(18)
                        
                        VStack {
                            Image(systemName: "phone.fill")
                                .font(.system(size: 50))
                            Text("Assistance")
                                .font(.system(size: 25, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 130)
                        .background(Color(hex: 0xE0E0E0))
                        .foregroundColor(.black)
                        .cornerRadius(18)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    HomeView(isLoggedIn: .constant(true), currentUsername: .constant(""))
        .modelContainer(for: User.self, inMemory: true)
}
