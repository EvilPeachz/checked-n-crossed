import SwiftUI

struct TaskEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var task: TaskItem
    let isPro: Bool
    let onLocked: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Task") {
                    TextField("Title", text: $task.title)
                    TextField("Notes", text: $task.notes, axis: .vertical)
                }

                Section("Priority") {
                    Picker("Priority", selection: Binding(
                        get: { task.priority },
                        set: { newValue in
                            guard isPro else { onLocked(); return }
                            task.priority = newValue
                        }
                    )) {
                        ForEach(PriorityLevel.allCases) { level in
                            Text(level.title).tag(level)
                        }
                    }
                }

                Section("Schedule") {
                    Picker("Type", selection: Binding(
                        get: { task.scheduleType },
                        set: { newValue in
                            guard isPro || newValue == .none else { onLocked(); return }
                            task.scheduleType = newValue
                        }
                    )) {
                        Text("Off").tag(ScheduleType.none)
                        Text("On").tag(ScheduleType.dailyOn)
                        Text("Recurring").tag(ScheduleType.recurring)
                    }

                    if task.scheduleType == .recurring {
                        Picker("Rule", selection: Binding($task.recurringRule, replacingNilWith: .daily)) {
                            ForEach(RecurringRule.allCases) { rule in
                                Text(rule.rawValue.capitalized).tag(Optional(rule))
                            }
                        }
                    }

                    Toggle("Move unfinished to next day", isOn: Binding(
                        get: { task.moveUnfinishedForward },
                        set: { newValue in
                            guard isPro || !newValue else { onLocked(); return }
                            task.moveUnfinishedForward = newValue
                        }
                    ))
                }
            }
            .navigationTitle("Edit Task")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

private extension Binding {
    init(_ source: Binding<Value?>, replacingNilWith nilReplacement: Value) {
        self.init(
            get: { source.wrappedValue ?? nilReplacement },
            set: { source.wrappedValue = $0 }
        )
    }
}
