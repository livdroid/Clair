//
//  MeetingParticipant.swift
//  Clair
//
//  Created by olivia on 17/06/2026.
//


import Foundation
import SwiftData

@Model
final class MeetingParticipant {
    var id: UUID
    var displayName: String
    var isUser: Bool

    init(
        id: UUID = UUID(),
        displayName: String,
        isUser: Bool = false
    ) {
        self.id = id
        self.displayName = displayName
        self.isUser = isUser
    }
}