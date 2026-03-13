import Foundation
import SwiftData

@Model
class User {
    var username: String
    var password: String
    var fullName: String
    var email: String
    var phoneNumber: String
    var role: String
    var address: String
    @Attribute(.externalStorage) var avatarData: Data?
    var conditions: String?
    var allergies: String?
    var height: String?
    var weight: String?
    @Relationship(deleteRule: .cascade) var medications: [Medication]
    @Relationship(deleteRule: .cascade) var appointments: [Appointment]
    @Relationship(deleteRule: .cascade) var familyMembers: [FamilyMember]

    init(
        username: String,
        password: String,
        fullName: String,
        email: String,
        phoneNumber: String,
        role: String = "senior",
        address: String = "Not added yet",
        avatarData: Data? = nil,
        conditions: String? = nil,
        allergies: String? = nil,
        height: String? = nil,
        weight: String? = nil,
        medications: [Medication] = [],
        appointments: [Appointment] = [],
        familyMembers: [FamilyMember] = []
    ) {
        self.username = username
        self.password = password
        self.fullName = fullName
        self.email = email
        self.phoneNumber = phoneNumber
        self.role = role
        self.address = address
        self.avatarData = avatarData
        self.conditions = conditions
        self.allergies = allergies
        self.height = height
        self.weight = weight
        self.medications = medications
        self.appointments = appointments
        self.familyMembers = familyMembers
    }
} 