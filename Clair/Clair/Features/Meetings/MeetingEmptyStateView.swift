//
//  MeetingEmptyStateView.swift
//  Clair
//
//  Created by olivia on 17/06/2026.
//

import SwiftUI

struct MeetingEmptyStateView: View {
    var body: some View {
        ContentUnavailableView(
            "No meetings available",
            systemImage: "mic",
            description: Text("Create or select a meeting to start")
        )
    }
}
