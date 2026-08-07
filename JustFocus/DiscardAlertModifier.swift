//
//  DiscardAlertModifier.swift
//  MyFriends
//
//  Created by Mac on 06/08/26.
//

import SwiftUI

struct DiscardAlertModifier: ViewModifier {
    @Binding var show: Bool
    let isEdited: Bool
    @State private var showConfirmation = false

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        if isEdited {
                            showConfirmation.toggle()
                        } else {
                            show = false
                        }
                    } label: {
                        Label("X", systemImage: "x.mark")
                    }
                    .alert("Discard Changes?", isPresented: $showConfirmation) {
                        Button("Discard", role: .destructive) { show = false }
                        Button("Keep Editing", role: .cancel) { }
                    } message: {
                        Text("Your unsaved changes will be lost.")
                    }
                }
            }
    }
}

extension View {
    func discardAlert(show: Binding<Bool>, isEdited: Bool) -> some View {
        modifier(DiscardAlertModifier(show: show, isEdited: isEdited))
    }
}
