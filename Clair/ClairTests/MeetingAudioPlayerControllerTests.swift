//
//  MeetingAudioPlayerControllerTests.swift
//  Clair
//
//  Created by olivia on 23/06/2026.
//

import XCTest

@testable import Clair

@MainActor
final class MeetingAudioPlayerControllerTests: XCTestCase {
    func testNilPathKeepsControllerIdle() {
        let service = MockAudioPlaybackService()
        let controller = MeetingAudioPlayerController(service: service)

        controller.load(path: nil)

        XCTAssertEqual(controller.state, .idle)
        XCTAssertEqual(controller.duration, 0)
        XCTAssertEqual(service.loadCallCount, 0)
    }

    func testMissingFileMovesControllerToFailed() {
        let service = MockAudioPlaybackService()
        let controller = MeetingAudioPlayerController(service: service)

        controller.load(path: "/tmp/clair-file-that-does-not-exist.m4a")

        XCTAssertEqual(
            controller.state,
            .failed(
                message: AudioPlaybackError.fileNotFound.localizedDescription
            )
        )
        XCTAssertEqual(service.loadCallCount, 0)
    }

    private func makeTemporaryAudioFile() throws -> URL {
        let url = FileManager.default.temporaryDirectory
            .appending(path: "\(UUID().uuidString).m4a")

        try Data().write(to: url)
        return url
    }

    func testValidFileLoadsController() throws {
        let url = try makeTemporaryAudioFile()
        defer { try? FileManager.default.removeItem(at: url) }

        let service = MockAudioPlaybackService()
        service.duration = 42
        let controller = MeetingAudioPlayerController(service: service)

        controller.load(path: url.path)

        XCTAssertEqual(controller.state, .ready)
        XCTAssertEqual(controller.duration, 42)
        XCTAssertEqual(controller.currentTime, 0)
        XCTAssertEqual(service.loadCallCount, 1)
    }

    func testToggleFromReadyStartsPlayback() throws {
        let url = try makeTemporaryAudioFile()
        defer { try? FileManager.default.removeItem(at: url) }

        let service = MockAudioPlaybackService()
        let controller = MeetingAudioPlayerController(service: service)
        controller.load(path: url.path)

        controller.togglePlayback()

        XCTAssertEqual(controller.state, .playing)
        XCTAssertEqual(service.playCallCount, 1)
    }

    func testToggleFromPlayingPausesPlayback() throws {
        let url = try makeTemporaryAudioFile()
        defer { try? FileManager.default.removeItem(at: url) }

        let service = MockAudioPlaybackService()
        let controller = MeetingAudioPlayerController(service: service)
        controller.load(path: url.path)
        controller.togglePlayback()

        controller.togglePlayback()

        XCTAssertEqual(controller.state, .paused)
        XCTAssertEqual(service.pauseCallCount, 1)
    }

    func testSeekIsClampedToAudioDuration() throws {
        let url = try makeTemporaryAudioFile()
        defer { try? FileManager.default.removeItem(at: url) }

        let service = MockAudioPlaybackService()
        service.duration = 30
        let controller = MeetingAudioPlayerController(service: service)
        controller.load(path: url.path)

        controller.seek(to: -10)
        XCTAssertEqual(controller.currentTime, 0)

        controller.seek(to: 100)
        XCTAssertEqual(controller.currentTime, 30)
        XCTAssertEqual(service.seekCallCount, 2)
    }

    func testPlayErrorMovesControllerToFailed() throws {
        let url = try makeTemporaryAudioFile()
        defer { try? FileManager.default.removeItem(at: url) }

        let service = MockAudioPlaybackService()
        service.playError = AudioPlaybackError.playbackFailed

        let controller = MeetingAudioPlayerController(service: service)
        controller.load(path: url.path)

        controller.togglePlayback()

        XCTAssertEqual(
            controller.state,
            .failed(
                message: AudioPlaybackError.playbackFailed.localizedDescription
            )
        )
        XCTAssertEqual(service.playCallCount, 1)
    }

    func testStopResetsLoadedAudioToReady() throws {
        let url = try makeTemporaryAudioFile()
        defer { try? FileManager.default.removeItem(at: url) }

        let service = MockAudioPlaybackService()
        let controller = MeetingAudioPlayerController(service: service)
        controller.load(path: url.path)
        controller.togglePlayback()
        controller.seek(to: 12)

        controller.stop()

        XCTAssertEqual(controller.state, .ready)
        XCTAssertEqual(controller.currentTime, 0)
        XCTAssertEqual(service.stopCallCount, 2)
    }

    func testLoadingAnotherFileStopsPreviousAudio() throws {
        let firstURL = try makeTemporaryAudioFile()
        let secondURL = try makeTemporaryAudioFile()

        defer {
            try? FileManager.default.removeItem(at: firstURL)
            try? FileManager.default.removeItem(at: secondURL)
        }

        let service = MockAudioPlaybackService()
        let controller = MeetingAudioPlayerController(service: service)
        controller.load(path: firstURL.path)
        controller.togglePlayback()

        controller.load(path: secondURL.path)

        XCTAssertEqual(controller.state, .ready)
        XCTAssertEqual(service.loadCallCount, 2)
        XCTAssertEqual(service.stopCallCount, 2)
        XCTAssertFalse(service.isPlaying)
    }
}
