import Foundation
import SwiftData

@Model
class FamilyMember {
    var id: UUID
    var name: String
    var relation: String
    var phone: String

    @Relationship(inverse: \User.familyMembers) var user: User?

    init(
        id: UUID = UUID(),
        name: String,
        relation: String,
        phone: String,
        user: User? = nil
    ) {
        self.id = id
        self.name = name
        self.relation = relation
        self.phone = phone
        self.user = user
    }
}

