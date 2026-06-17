//
//  Meeting.swift
//  Clair
//
//  Created by olivia on 17/06/2026.
//

import Foundation
import SwiftData

@Model
final class Meeting {
    var id: UUID
    var title: String
    var createdAt: Date
    var updatedAt: Date
    var startedAt: Date?
    var endedAt: Date?
    var duration: TimeInterval?
    var audioFilePath: String?

    @Relationship(deleteRule: .cascade)
    var participants: [MeetingParticipant]

    @Relationship(deleteRule: .cascade)
    var transcriptSegments: [TranscriptSegment]

    @Relationship(deleteRule: .cascade)
    var actionItems: [ActionItem]

    var shortSummary: String
    var decisions: [String]
    var openQuestions: [String]

    init(
        id: UUID = UUID(),
        title: String,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        startedAt: Date? = nil,
        endedAt: Date? = nil,
        duration: TimeInterval? = nil,
        audioFilePath: String? = nil,
        participants: [MeetingParticipant] = [],
        transcriptSegments: [TranscriptSegment] = [],
        actionItems: [ActionItem] = [],
        shortSummary: String = "",
        decisions: [String] = [],
        openQuestions: [String] = []
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.duration = duration
        self.audioFilePath = audioFilePath
        self.participants = participants
        self.transcriptSegments = transcriptSegments
        self.actionItems = actionItems
        self.shortSummary = shortSummary
        self.decisions = decisions
        self.openQuestions = openQuestions
    }
}
