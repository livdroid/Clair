//
//  AVAudioRecordingService.swift
//  Clair
//
//  Created by olivia on 19/06/2026.
//


import AVFAudio
import Foundation

@MainActor
final class AVAudioRecordingService: NSObject, AudioRecordingService {
    private let fileStore: AudioFileStore
    private var recorder: AVAudioRecorder?

    var isRecording: Bool {
        recorder?.isRecording == true
    }

    init(fileStore: AudioFileStore = AudioFileStore()) {
        self.fileStore = fileStore
    }

    func requestPermission() async -> Bool {
        switch AVAudioApplication.shared.recordPermission {
        case .granted:
            true
        case .denied:
            false
        case .undetermined:
            await AVAudioApplication.requestRecordPermission()
        @unknown default:
            false
        }
    }

    func startRecording(meetingID: UUID) throws {
        guard recorder == nil else {
            throw AudioRecordingError.alreadyRecording
        }

        do {
            try fileStore.createRecordingsDirectoryIfNeeded()
        } catch {
            throw AudioRecordingError.unableToCreateDirectory
        }

        let fileURL = fileStore.recordingURL(for: meetingID)
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44_100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        let newRecorder = try AVAudioRecorder(
            url: fileURL,
            settings: settings
        )

        newRecorder.prepareToRecord()

        guard newRecorder.record() else {
            throw AudioRecordingError.unableToStart
        }

        recorder = newRecorder
    }

    func stopRecording() throws -> RecordedAudio {
        guard let recorder else {
            throw AudioRecordingError.notRecording
        }

        let duration = recorder.currentTime
        let fileURL = recorder.url

        recorder.stop()
        self.recorder = nil

        return RecordedAudio(
            fileURL: fileURL,
            duration: duration
        )
    }
}
