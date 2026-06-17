//
//  ActionItem.swift
//  Clair
//
//  Created by olivia on 17/06/2026.
//


import Foundation
import SwiftData

@Model
final class ActionItem {
    var id: UUID
    var text: String
    var assigneeName: String?
    var isDone: Bool

    init(
        id: UUID = UUID(),
        text: String,
        assigneeName: String? = nil,
        isDone: Bool = false
    ) {
        self.id = id
        self.text = text
        self.assigneeName = assigneeName
        self.isDone = isDone
    }
}