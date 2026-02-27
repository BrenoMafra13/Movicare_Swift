import SwiftUI
import SwiftData

@main
struct MovicareApp: App {
    @State private var isLoggedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                NavigationStack {
                    HomeView(isLoggedIn: $isLoggedIn)
                }
            } else {
                WelcomeView(isLoggedIn: $isLoggedIn)
            }
        }
        .modelContainer(for: User.self)
    }
}
