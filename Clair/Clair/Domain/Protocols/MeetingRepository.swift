//
//  MeetingRepository.swift
//  Clair
//
//  Created by olivia on 17/06/2026.
//

import Foundation

protocol MeetingRepository: Sendable {
    func fetchMeetings() async throws -> [Meeting]
    func saveMeeting(_ meeting: Meeting) async throws
    func deleteMeeting(id: UUID) async throws
}
