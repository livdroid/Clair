//
//  AVAudioRecordingService.swift
//  Clair
//
//  Created by olivia on 18/06/2026.
//

import Foundation

@MainActor
protocol AudioRecordingService: AnyObject {
    var isRecording: Bool { get }

    func requestPermission() async -> Bool
    func startRecording(meetingID: UUID) throws
    func stopRecording() throws -> RecordedAudio
}
