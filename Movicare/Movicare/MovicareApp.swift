import SwiftUI
import SwiftData

@main
struct MovicareApp: App {
    @State private var isLoggedIn: Bool = false
    @State private var currentUsername: String = ""

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                NavigationStack {
                    HomeView(isLoggedIn: $isLoggedIn, currentUsername: $currentUsername)
                }
            } else {
                WelcomeView(isLoggedIn: $isLoggedIn, currentUsername: $currentUsername)
            }
        }
        .modelContainer(for: [User.self, Medication.self, Appointment.self, FamilyMember.self])
    }
}
