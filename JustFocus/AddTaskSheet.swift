//
//  AddTaskSheet.swift
//  JustFocus
//
//  Created by Mac on 04/08/26.
//

import SwiftUI
import SwiftData

struct AddTaskSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var editingTask: TaskItem?
    
    @State private var title: String
    @State private var description: String
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var dueTime: Date
    @State private var note: String
    
    @State private var isPresented = true
    
    private var isEdited: Bool {
        if let editingTask {
            return title != editingTask.title ||
            description != editingTask.taskDescription ||
            note != editingTask.note
        } else {
            return !title.isEmpty || !description.isEmpty || !note.isEmpty
        }
    }
    
    init(editingTask: TaskItem? = nil) {
        self.editingTask = editingTask
        _title = State(initialValue: editingTask?.title ?? "")
        _description = State(initialValue: editingTask?.taskDescription ?? "")
        _startDate = State(initialValue: editingTask?.startDate ?? Date())
        _endDate = State(initialValue: editingTask?.dueDate ?? Date())
        _dueTime = State(initialValue: editingTask?.dueDate ?? Date())
        _note = State(initialValue: editingTask?.note ?? "")
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Tugas") {
                    TextField("Judul Tugas", text: $title)
                    TextField("Deskripsi Tugas", text: $description, axis: .vertical)
                }
                
                Section("Tenggat Waktu") {
                    DatePicker("Mulai", selection: $startDate, displayedComponents: .date)
                    DatePicker("Selesai", selection: $endDate, displayedComponents: .date)
                    DatePicker("Waktu", selection: $dueTime, displayedComponents: .hourAndMinute)
                }
                
                Section("Catatan") {
                    TextEditor(text: $note)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle(editingTask == nil ? "Add New Task" : "Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        let combinedDate = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: dueTime), minute: Calendar.current.component(.minute, from: dueTime), second: 0, of: endDate) ?? endDate
                        
                        if let editingTask {
                            editingTask.title = title
                            editingTask.taskDescription = description
                            editingTask.startDate = startDate
                            editingTask.dueDate = combinedDate
                            editingTask.note = note
                        } else {
                            let newTask = TaskItem(title: title, taskDescription: description, startDate: startDate, dueDate: combinedDate, note: note, isPinned: false)
                            modelContext.insert(newTask)
                        }
                        try? modelContext.save()
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .disabled(title.isEmpty)
                    .buttonStyle(.glassProminent)
                    .tint(.orange)
                    
                }
            }
            .discardAlert(show: $isPresented, isEdited: isEdited)
            .onChange(of: isPresented) { _, newValue in
                if !newValue {
                    dismiss()
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
#Preview {
    AddTaskSheet()
}
