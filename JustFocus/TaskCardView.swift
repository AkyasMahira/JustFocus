//
//  TaskCardView.swift
//  JustFocus
//
//  Created by Mac on 04/08/26.
//

import SwiftUI

struct TaskCardView: View {
    let task: TaskItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(task.title)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text(task.taskDescription)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            Text(task.dueDate, format: .dateTime.day().month().year())
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TaskCardView(task: TaskItem(title: "Judul", taskDescription: "Des", dueDate: Date(), note: "Note", isCompleted: false))
}
