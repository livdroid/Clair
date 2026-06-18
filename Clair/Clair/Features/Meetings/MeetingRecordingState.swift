//
//  MeetingRecordingState.swift
//  Clair
//
//  Created by olivia on 19/06/2026.
//


import Foundation

enum MeetingRecordingState: Equatable {
    case idle
    case requestingPermission
    case recording(startedAt: Date)
    case saving
    case failed(message: String)
}