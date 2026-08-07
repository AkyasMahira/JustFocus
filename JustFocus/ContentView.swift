//
//  ContentView.swift
//  JustFocus
//
//  Created by Mac on 04/08/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            FocusView()
                .tabItem {
                    Label("Focus", systemImage: "target")
                }
            CalendarReal()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [TaskItem.self, CompletedDay.self])
}
