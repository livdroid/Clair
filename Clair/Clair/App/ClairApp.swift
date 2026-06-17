//
//  ClairApp.swift
//  Clair
//
//  Created by olivia on 17/06/2026.
//

import SwiftUI
import SwiftData

@main
struct ClairApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            Meeting.self,
            MeetingParticipant.self,
            TranscriptSegment.self,
            ActionItem.self
        ])
    }
}
