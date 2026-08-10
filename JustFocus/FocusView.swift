//
//  FocusView.swift
//  JustFocus
//
//  Created by Mac on 04/08/26.
//

import SwiftUI
import SwiftData

struct FocusView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskItem.dueDate) private var allTasks: [TaskItem]
    @Query private var completedDays: [CompletedDay]
    @State private var showAddTaskSheet = false
    @State private var showCongrats = false
    
    private var tasks: [TaskItem] {
        allTasks.filter { !$0.isCompleted && Calendar.current.isDateInToday($0.startDate) }
    }
    
    private var sortedTasks: [TaskItem] {
        tasks.sorted { task1, task2 in
            if task1.isPinned != task2.isPinned {
                return task1.isPinned && !task2.isPinned
            }
            return task1.dueDate < task2.dueDate
        }
    }
    
    // guard untuk menghindari duplikasi data (10 task selesai hari ini ttp dihitung 1)
    private func recordCompletionDay() {
        let today = Calendar.current.startOfDay(for: .now)
        let existing = (try? modelContext.fetch(FetchDescriptor<CompletedDay>())) ?? []
        if !existing.contains(where: { Calendar.current.startOfDay(for: $0.date) == today }) {
            modelContext.insert(CompletedDay(date: today))
            try? modelContext.save()
        }
    }
    
    // ke triger pas button selesai dipencet (check untuk menampilmkan congrats screen)
    private func handleTaskCompleted(_ completed: TaskItem) {
        recordCompletionDay()
        guard Calendar.current.isDateInToday(completed.startDate) else { return }
        let remainingToday = allTasks.filter { !$0.isCompleted && Calendar.current.isDateInToday($0.startDate) }
        guard remainingToday.isEmpty else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showCongrats = true
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if tasks.isEmpty {
                    ContentUnavailableView(
                        "No Task for Today",
                        systemImage: "target",
                        description: Text("Tambahkan tugasmu untuk mulai fokus")
                    )
                } else {
                    List {
                        ForEach(sortedTasks) { task in
                            NavigationLink {
                                TaskDetail(task: task, onCompleted: handleTaskCompleted)
                            } label: {
                                TaskCardView(task: task)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    modelContext.delete(task)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    task.isPinned.toggle()
                                } label: {
                                    Label(
                                        task.isPinned ? "Unpin" : "Pin",
                                        systemImage: task.isPinned ? "pin.slash.fill" : "pin.fill"
                                    )
                                }
                                .tint(task.isPinned ? .gray : .blue)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .animation(.snappy(duration: 0.35), value: sortedTasks.map(\.id))
                }
            }
            .navigationTitle("Focus")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddTaskSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddTaskSheet) {
                AddTaskSheet()
            }
            .fullScreenCover(isPresented: $showCongrats) {
                CongratsScreen(streak: StreakCalculator.currentStreak(days: completedDays, tasks: allTasks))
            }
        }
    }
}

#Preview {
    FocusView()
        .modelContainer(for: [TaskItem.self, CompletedDay.self])
}
