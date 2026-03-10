import Foundation
import SwiftData

@Model
class Medication {
    var id: UUID
    var name: String
    var dosage: String
    var startDate: Date
    var endDate: Date
    var time: Date
    var takenDosesCount: Int
    var snoozedUntil: Date?
    var snoozedForDay: Date?

    @Relationship(inverse: \User.medications) var user: User?

    init(
        id: UUID = UUID(),
        name: String,
        dosage: String,
        startDate: Date,
        endDate: Date,
        time: Date,
        takenDosesCount: Int = 0,
        snoozedUntil: Date? = nil,
        snoozedForDay: Date? = nil,
        user: User? = nil
    ) {
        self.id = id
        self.name = name
        self.dosage = dosage
        self.startDate = startDate
        self.endDate = endDate
        self.time = time
        self.takenDosesCount = takenDosesCount
        self.snoozedUntil = snoozedUntil
        self.snoozedForDay = snoozedForDay
        self.user = user
    }
}