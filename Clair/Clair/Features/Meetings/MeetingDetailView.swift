//
//  MeetingDetailView.swift
//  Clair
//
//  Created by olivia on 17/06/2026.
//

import SwiftData
import SwiftUI

struct MeetingDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var meeting: Meeting

    var body: some View {
        Form {
            Section("Informations") {
                TextField("Title", text: $meeting.title)
                Text(
                    meeting.createdAt.formatted(
                        date: .abbreviated,
                        time: .shortened
                    )
                )
                .foregroundStyle(.secondary)
            }
        }
        .padding()
        .onChange(of: meeting.title) { _, _ in
            meeting.updatedAt = .now
            save()
        }
    }

    private func save() {
        do { try modelContext.save() } catch {
            print("Impossible to save meeting:", error)
        }
    }
}
