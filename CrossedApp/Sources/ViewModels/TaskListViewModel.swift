import Foundation
import SwiftData

@MainActor
final class TaskListViewModel: ObservableObject {
    @Published var selectedDate: Date = .now
    @Published var layoutMode: LayoutMode = .oneColumn
    @Published var showingPaywall = false

    var isPro: Bool = false

    func canUseProFeature() -> Bool {
        if isPro { return true }
        showingPaywall = true
        return false
    }

    func shiftDate(by days: Int) {
        selectedDate = Calendar.current.date(byAdding: .day, value: days, to: selectedDate) ?? selectedDate
    }

    func filteredTasks(_ tasks: [TaskItem]) -> [TaskItem] {
        tasks.filter { SchedulingService.shouldAppear($0, on: selectedDate) }
    }

    func groupedTasks(_ tasks: [TaskItem]) -> [PriorityLevel: [TaskItem]] {
        TaskSortingService.groupedAndSortedTasks(for: filteredTasks(tasks), on: selectedDate)
    }
}
