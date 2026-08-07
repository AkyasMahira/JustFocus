//
//  TaskItem.swift
//  JustFocus
//
//  Created by Mac on 04/08/26.
//

import Foundation
import SwiftData

@Model
final class TaskItem {
    var id: UUID
    var title: String
    var taskDescription: String
    var dueDate: Date
    var note: String
    var isCompleted: Bool = false
    var isPinned: Bool = false
    
    init(id: UUID = UUID(), title: String, taskDescription: String, dueDate: Date, note: String, isCompleted: Bool = false, isPinned: Bool = false) {
        self.id = id
        self.title = title
        self.taskDescription = taskDescription
        self.dueDate = dueDate
        self.note = note
        self.isCompleted = isCompleted
        self.isPinned = isPinned
    }
}
