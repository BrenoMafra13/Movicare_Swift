import Foundation
import SwiftData

@Model
class User {
    @Attribute(.unique) var username: String
    var password: String
    var fullName: String
    var email: String
    var phoneNumber: String

    init(username: String, password: String, fullName: String, email: String, phoneNumber: String) {
        self.username = username
        self.password = password
        self.fullName = fullName
        self.email = email
        self.phoneNumber = phoneNumber
    }
}