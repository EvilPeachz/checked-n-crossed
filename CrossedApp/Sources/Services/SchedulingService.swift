import Foundation

struct SchedulingService {
    static func shouldAppear(_ task: TaskItem, on date: Date, calendar: Calendar = .current) -> Bool {
        switch task.scheduleType {
        case .none:
            if let dueDate = task.dueDate {
                return calendar.isDate(dueDate, inSameDayAs: date)
            }
            return true
        case .dailyOn:
            return true
        case .recurring:
            guard let rule = task.recurringRule else { return false }
            if let endDate = task.recurringEndDate, date > endDate { return false }
            return matchesRecurringRule(rule, taskDate: task.createdAt, targetDate: date, calendar: calendar)
        }
    }

    static func matchesRecurringRule(_ rule: RecurringRule, taskDate: Date, targetDate: Date, calendar: Calendar) -> Bool {
        switch rule {
        case .daily:
            return targetDate >= calendar.startOfDay(for: taskDate)
        case .weekdays:
            let weekday = calendar.component(.weekday, from: targetDate)
            return (2...6).contains(weekday)
        case .weekly:
            let taskWeekday = calendar.component(.weekday, from: taskDate)
            let targetWeekday = calendar.component(.weekday, from: targetDate)
            return taskWeekday == targetWeekday && targetDate >= taskDate
        case .monthly:
            let taskDay = calendar.component(.day, from: taskDate)
            let targetDay = calendar.component(.day, from: targetDate)
            return taskDay == targetDay && targetDate >= taskDate
        }
    }

    static func nextDayOccurrences(tasks: [TaskItem], from date: Date, calendar: Calendar = .current) -> [TaskOccurrence] {
        let nextDay = calendar.date(byAdding: .day, value: 1, to: date) ?? date
        return tasks.compactMap { task in
            guard task.moveUnfinishedForward, !task.isCompleted else { return nil }
            return TaskOccurrence(taskId: task.id, scheduledDate: nextDay)
        }
    }
}
