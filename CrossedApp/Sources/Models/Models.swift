import Foundation
import SwiftData

enum AuthProvider: String, Codable, CaseIterable {
    case apple
    case google
    case guest
}

enum PriorityLevel: Int, Codable, CaseIterable, Identifiable {
    case timeSensitive = 0
    case high = 1
    case medium = 2
    case low = 3

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .timeSensitive: return "Time-Sensitive"
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        }
    }
}

enum ScheduleType: String, Codable, CaseIterable, Identifiable {
    case none
    case dailyOn
    case recurring

    var id: String { rawValue }
}

enum RecurringRule: String, Codable, CaseIterable, Identifiable {
    case daily
    case weekdays
    case weekly
    case monthly

    var id: String { rawValue }
}

enum LayoutMode: String, CaseIterable, Identifiable, Codable {
    case oneColumn
    case twoColumns
    case threeColumns
    case stacked

    var id: String { rawValue }

    var title: String {
        switch self {
        case .oneColumn: return "1 Column"
        case .twoColumns: return "2 Columns"
        case .threeColumns: return "3 Columns"
        case .stacked: return "Stacked"
        }
    }

    var columnCount: Int {
        switch self {
        case .oneColumn: return 1
        case .twoColumns: return 2
        case .threeColumns: return 3
        case .stacked: return 1
        }
    }
}

@Model
final class UserProfile {
    @Attribute(.unique) var id: UUID
    var authProvider: AuthProvider
    var isPro: Bool

    init(id: UUID = UUID(), authProvider: AuthProvider, isPro: Bool = false) {
        self.id = id
        self.authProvider = authProvider
        self.isPro = isPro
    }
}

@Model
final class TaskItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var notes: String
    var priority: PriorityLevel
    var createdAt: Date
    var updatedAt: Date
    var isCompleted: Bool
    var completedAt: Date?
    var dueDate: Date?
    var scheduleType: ScheduleType
    var recurringRule: RecurringRule?
    var recurringEndDate: Date?
    var moveUnfinishedForward: Bool

    init(
        id: UUID = UUID(),
        title: String,
        notes: String = "",
        priority: PriorityLevel = .medium,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        isCompleted: Bool = false,
        completedAt: Date? = nil,
        dueDate: Date? = nil,
        scheduleType: ScheduleType = .none,
        recurringRule: RecurringRule? = nil,
        recurringEndDate: Date? = nil,
        moveUnfinishedForward: Bool = false
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.priority = priority
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isCompleted = isCompleted
        self.completedAt = completedAt
        self.dueDate = dueDate
        self.scheduleType = scheduleType
        self.recurringRule = recurringRule
        self.recurringEndDate = recurringEndDate
        self.moveUnfinishedForward = moveUnfinishedForward
    }
}

@Model
final class TaskOccurrence {
    @Attribute(.unique) var id: UUID
    var taskId: UUID
    var scheduledDate: Date
    var isCompleted: Bool
    var sortIndex: Int?

    init(
        id: UUID = UUID(),
        taskId: UUID,
        scheduledDate: Date,
        isCompleted: Bool = false,
        sortIndex: Int? = nil
    ) {
        self.id = id
        self.taskId = taskId
        self.scheduledDate = scheduledDate
        self.isCompleted = isCompleted
        self.sortIndex = sortIndex
    }
}
