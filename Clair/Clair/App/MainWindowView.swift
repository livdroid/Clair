//
//  ContentView.swift
//  Clair
//
//  Created by olivia on 17/06/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Meeting.createdAt, order: .reverse)
    private var meetings: [Meeting]

    var body: some View {
        VStack {
            Text("Test Meeting")
            Button("add") {
                let meeting = Meeting(title: "Test Meeting")
                modelContext.insert(meeting)
            }
            List(meetings) { meeting in
                Text(meeting.title)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
