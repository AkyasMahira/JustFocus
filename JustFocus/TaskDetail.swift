//
//  TaskDetail.swift
//  JustFocus
//
//  Created by Mac on 04/08/26.
//

import SwiftUI
import SwiftData

struct TaskDetail: View {
    @Environment(\.dismiss) private var dismiss
    let task: TaskItem
    var onCompleted: ((TaskItem) -> Void)? = nil
    @State private var showEditSheet = false
    @State private var showCompleteConfirmation = false
    
    private func completeTask() {
        task.isCompleted = true
        onCompleted?(task)
        dismiss()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                Text(task.taskDescription)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .lineSpacing(4)
                    .padding(.top, 4)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 16) {
                
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: "calendar")
                        .font(.title3)
                        .foregroundStyle(.brown)
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Tenggat Waktu")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(task.dueDate, format: .dateTime.day().month().year())
                            .font(.body)
                            .foregroundStyle(.primary)
                    }
                }
                
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: "doc.text")
                        .font(.title3)
                        .foregroundStyle(.brown)
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Catatan")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(task.note.isEmpty ? "Tidak ada catatan" : task.note)
                            .font(.body)
                            .foregroundStyle(task.note.isEmpty ? .secondary : .primary)
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.regularMaterial)
            )
            .padding(.horizontal)
        }
        .navigationTitle(task.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showEditSheet = true
                } label: {
                    Image(systemName: "pencil")
                }
                .buttonStyle(.glassProminent)
                .tint(.brown)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showCompleteConfirmation = true
                } label: {
                    Image(systemName: "checkmark")
                        .contentTransition(.symbolEffect(.replace))
                }
                .buttonStyle(.glassProminent)
                .tint(.orange)
            }
        }
        .sheet(isPresented: $showEditSheet) {
            AddTaskSheet(editingTask: task)
        }
        .alert("Complete Task?", isPresented: $showCompleteConfirmation) {
            Button("Complete", role: .destructive) {
                completeTask()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Tandai tugas ini sebagai selesai?")
        }
    }
}

#Preview {
    NavigationStack {
        TaskDetail(task: TaskItem(title: "Judul Tugas", taskDescription: "Lorem ipsum", dueDate: Date(), note: "Catatan"))
    }
    .modelContainer(for: TaskItem.self)
}
