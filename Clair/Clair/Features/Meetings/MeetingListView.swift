//
//  MeetingListView.swift
//  Clair
//
//  Created by olivia on 17/06/2026.
//

import SwiftData
import SwiftUI

struct MeetingListView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Meeting.createdAt, order: .reverse)
    private var meetings: [Meeting]

    @State private var selectedMeeting: Meeting?

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedMeeting) {
                ForEach(meetings) { meeting in
                    Button {
                            selectMeeting(meeting: meeting)
                        
                    } label: {
                        Text(meeting.title)
                    }
                        .tag(meeting as Meeting?)
                        
                }
            }
            .toolbar {
                Button("New Meeting") {
                    createMeeting()
                }
                if selectedMeeting != nil {
                    Button("Delete") {
                        deleteMeeting()
                    }
                }
            }
        } detail: {
            if let selectedMeeting {
                MeetingDetailView(meeting: selectedMeeting)
            } else {
                MeetingEmptyStateView()
            }
        }
    }

    private func createMeeting() {
        let dateTimeNow = Date.now.formatted(date: .abbreviated, time: .omitted)
        let meeting = Meeting(title: "Meeting \(dateTimeNow)")
        modelContext.insert(meeting)

        do {
            try modelContext.save()
            selectedMeeting = meeting
        } catch {
            print("Can't save meeting:", error)
        }
    }
    
    private func deleteMeeting() {
        do {
            if let meeting = selectedMeeting {
                modelContext.delete(meeting)
                try modelContext.save()
                selectedMeeting = nil
            }
        } catch {
            print("Can't delete meeting:", error)
        }
    }
    
    private func selectMeeting(meeting: Meeting?) {
        guard let meeting else {
            return
        }
       selectedMeeting = meeting
    }
}
