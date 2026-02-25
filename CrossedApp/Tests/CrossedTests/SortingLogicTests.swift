import XCTest
@testable import Crossed

final class SortingLogicTests: XCTestCase {
    func testIncompleteBeforeCompleteWithinPriority() {
        let incomplete = TaskItem(title: "A", isCompleted: false)
        let complete = TaskItem(title: "B", isCompleted: true)
        let sorted = [complete, incomplete].sorted {
            TaskSortingService.compare(lhs: $0, rhs: $1, date: .now, calendar: .current)
        }
        XCTAssertEqual(sorted.first?.title, "A")
    }

    func testEarlierDueDateComesFirst() {
        let today = Date()
        let earlier = TaskItem(title: "A", dueDate: today)
        let later = TaskItem(title: "B", dueDate: Calendar.current.date(byAdding: .day, value: 1, to: today))

        let sorted = [later, earlier].sorted {
            TaskSortingService.compare(lhs: $0, rhs: $1, date: today, calendar: .current)
        }
        XCTAssertEqual(sorted.first?.title, "A")
    }

    func testNoDueDateUsesRecentCreationFirst() {
        let old = TaskItem(title: "Old", createdAt: Date(timeIntervalSince1970: 100))
        let recent = TaskItem(title: "Recent", createdAt: Date(timeIntervalSince1970: 200))

        let sorted = [old, recent].sorted {
            TaskSortingService.compare(lhs: $0, rhs: $1, date: .now, calendar: .current)
        }
        XCTAssertEqual(sorted.first?.title, "Recent")
    }
}
