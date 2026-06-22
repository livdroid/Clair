//
//  MockAudioRecordingService.swift
//  Clair
//
//  Created by olivia on 19/06/2026.
//


import Foundation
@testable import Clair

@MainActor
final class MockAudioRecordingService: AudioRecordingService {
    var isRecording = false
    var permissionGranted = true
    var startError: Error?
    var stopError: Error?

    var recordedAudio = RecordedAudio(
        fileURL: URL(filePath: "/tmp/test-recording.m4a"),
        duration: 42
    )

    func requestPermission() async -> Bool {
        permissionGranted
    }

    func startRecording(meetingID: UUID) throws {
        if let startError {
            throw startError
        }

        isRecording = true
    }

    func stopRecording() throws -> RecordedAudio {
        if let stopError {
            throw stopError
        }

        isRecording = false
        return recordedAudio
    }
}
