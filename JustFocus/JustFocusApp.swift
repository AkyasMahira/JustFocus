//
//  JustFocusApp.swift
//  JustFocus
//
//  Created by Mac on 04/08/26.
//

import SwiftUI
import SwiftData

@main
struct JustFocusApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: TaskItem.self)
    }
}
