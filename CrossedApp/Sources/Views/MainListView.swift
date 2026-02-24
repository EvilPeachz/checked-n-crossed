import SwiftData
import SwiftUI

struct MainListView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var purchaseService: PurchaseService
    @StateObject private var viewModel = TaskListViewModel()
    @Query private var tasks: [TaskItem]
    @State private var editingTask: TaskItem?

    var body: some View {
        ZStack {
            LegalPadBackground()
            VStack(spacing: 0) {
                header
                content
                addButton
            }
            .padding(.horizontal)
        }
        .sheet(item: $editingTask) { task in
            TaskEditView(task: task, isPro: viewModel.isPro) {
                viewModel.showingPaywall = true
            }
        }
        .sheet(isPresented: $viewModel.showingPaywall) {
            UpgradeView()
                .environmentObject(purchaseService)
        }
        .onAppear {
            viewModel.isPro = purchaseService.hasPro
        }
        .onChange(of: purchaseService.hasPro) { _, newValue in
            viewModel.isPro = newValue
        }
    }

    private var header: some View {
        HStack {
            Button {
                if viewModel.canUseProFeature() { viewModel.shiftDate(by: -1) }
            } label: { Image(systemName: "chevron.left") }

            Spacer()
            Text(viewModel.selectedDate.formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day()))
                .font(.headline)
                .onTapGesture {
                    if !viewModel.canUseProFeature() { return }
                }
                .accessibilityLabel("Selected date")
            Spacer()

            Menu {
                ForEach(LayoutMode.allCases) { mode in
                    Button(mode.title) {
                        guard viewModel.isPro || mode == .oneColumn else {
                            viewModel.showingPaywall = true
                            return
                        }
                        viewModel.layoutMode = mode
                    }
                }
            } label: {
                Image(systemName: "rectangle.grid.1x2")
            }
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gearshape")
            }
        }
        .font(.title3)
        .padding(.vertical, 12)
    }

    private var content: some View {
        ScrollView {
            let grouped = viewModel.groupedTasks(tasks)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: viewModel.layoutMode.columnCount), spacing: 12) {
                ForEach(PriorityLevel.allCases) { priority in
                    let items = grouped[priority] ?? []
                    if !items.isEmpty {
                        Section {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(priority.title)
                                    .font(.headline)
                                ForEach(items) { task in
                                    taskRow(task)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .background(.ultraThinMaterial.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
            .padding(.bottom, 20)
        }
        .gesture(DragGesture(minimumDistance: 20).onEnded { value in
            guard viewModel.isPro else { return }
            if value.translation.width < -40 { viewModel.shiftDate(by: 1) }
            if value.translation.width > 40 { viewModel.shiftDate(by: -1) }
        })
    }

    private func taskRow(_ task: TaskItem) -> some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .onTapGesture {
                    task.isCompleted.toggle()
                    task.completedAt = task.isCompleted ? .now : nil
                    task.updatedAt = .now
                }
            Text(task.title)
                .strikethrough(task.isCompleted)
                .onTapGesture { editingTask = task }
            Spacer()
            if let due = task.dueDate {
                Text(due, style: .date)
                    .font(.caption)
            }
        }
        .contentShape(Rectangle())
        .swipeActions {
            Button(role: .destructive) {
                modelContext.delete(task)
            } label: { Label("Delete", systemImage: "trash") }

            if viewModel.isPro {
                Button {
                    task.dueDate = Calendar.current.date(byAdding: .day, value: 1, to: .now)
                } label: { Label("Tomorrow", systemImage: "arrowshape.turn.up.right") }
                .tint(.indigo)
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                task.isCompleted.toggle()
            } label: {
                Label(task.isCompleted ? "Uncomplete" : "Complete", systemImage: "checkmark")
            }
            .tint(.green)
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("Double-tap to edit task")
    }

    private var addButton: some View {
        Button {
            let task = TaskItem(title: "New Task")
            modelContext.insert(task)
            editingTask = task
        } label: {
            Label("Add", systemImage: "plus.circle.fill")
                .font(.title2)
        }
        .padding(.vertical, 10)
    }
}
