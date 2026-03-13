import Foundation
import SwiftData

@Model
class Appointment {
    var id: UUID
    var type: String
    var scheduledAt: Date

    @Relationship(inverse: \User.appointments) var user: User?

    init(
        id: UUID = UUID(),
        type: String,
        scheduledAt: Date,
        user: User? = nil
    ) {
        self.id = id
        self.type = type
        self.scheduledAt = scheduledAt
        self.user = user
    }
}