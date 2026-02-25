import Foundation

struct TaskSortingService {
    static func groupedAndSortedTasks(for tasks: [TaskItem], on date: Date, calendar: Calendar = .current) -> [PriorityLevel: [TaskItem]] {
        let grouped = Dictionary(grouping: tasks, by: \.priority)
        var result: [PriorityLevel: [TaskItem]] = [:]

        for priority in PriorityLevel.allCases {
            let sorted = (grouped[priority] ?? []).sorted { lhs, rhs in
                compare(lhs: lhs, rhs: rhs, date: date, calendar: calendar)
            }
            result[priority] = sorted
        }

        return result
    }

    static func compare(lhs: TaskItem, rhs: TaskItem, date: Date, calendar: Calendar) -> Bool {
        if lhs.isCompleted != rhs.isCompleted {
            return !lhs.isCompleted
        }

        let lhsDueRank = dueRank(for: lhs, date: date, calendar: calendar)
        let rhsDueRank = dueRank(for: rhs, date: date, calendar: calendar)
        if lhsDueRank != rhsDueRank {
            return lhsDueRank < rhsDueRank
        }

        switch (lhs.dueDate, rhs.dueDate) {
        case let (.some(ld), .some(rd)):
            if ld != rd { return ld < rd }
            return lhs.createdAt > rhs.createdAt
        case (.some, .none):
            return true
        case (.none, .some):
            return false
        case (.none, .none):
            return lhs.createdAt > rhs.createdAt
        }
    }

    private static func dueRank(for task: TaskItem, date: Date, calendar: Calendar) -> Int {
        guard let due = task.dueDate else { return 2 }
        if due < calendar.startOfDay(for: date) { return 0 }
        if calendar.isDate(due, inSameDayAs: date) { return 1 }
        return 2
    }
}
