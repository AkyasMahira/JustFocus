//
//  StreakCalculator.swift
//  JustFocus
//
//  Created by Mac on 07/08/26.
//

import Foundation

enum StreakCalculator {
    static func completedDays(_ days: [CompletedDay]) -> Set<Date> {
        Set(days.map { Calendar.current.startOfDay(for: $0.date) })
    }
    
    // freeze
    static func currentStreak(days: [CompletedDay], tasks: [TaskItem]) -> Int {
        let startOfToday = Calendar.current.startOfDay(for: .now)
        let hasOverdue = tasks.contains { !$0.isCompleted && $0.dueDate < startOfToday }
        if hasOverdue {
            return 0
        }
        return completedDays(days).count
    }
}
