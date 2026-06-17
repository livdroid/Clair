//
//  TranscriptSegment.swift
//  Clair
//
//  Created by olivia on 17/06/2026.
//


import Foundation
import SwiftData

@Model
final class TranscriptSegment {
    var id: UUID
    var startTime: TimeInterval
    var endTime: TimeInterval
    var text: String
    var speakerLabel: String?

    init(
        id: UUID = UUID(),
        startTime: TimeInterval,
        endTime: TimeInterval,
        text: String,
        speakerLabel: String? = nil
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.text = text
        self.speakerLabel = speakerLabel
    }
}