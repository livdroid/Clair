//
//  MockAudioPlaybackService.swift
//  Clair
//
//  Created by olivia on 23/06/2026.
//

import Foundation
@testable import Clair

@MainActor
final class MockAudioPlaybackService: AudioPlaybackService {
    var duration: TimeInterval = 30
    var currentTime: TimeInterval = 0
    var isPlaying = false

    var loadError: Error?
    var playError: Error?

    private(set) var loadCallCount = 0
    private(set) var playCallCount = 0
    private(set) var pauseCallCount = 0
    private(set) var stopCallCount = 0
    private(set) var seekCallCount = 0

    func load(url: URL) throws {
        loadCallCount += 1

        if let loadError {
            throw loadError
        }
    }

    func play() throws {
        playCallCount += 1

        if let playError {
            throw playError
        }

        isPlaying = true
    }

    func pause() {
        pauseCallCount += 1
        isPlaying = false
    }

    func stop() {
        stopCallCount += 1
        isPlaying = false
        currentTime = 0
    }

    func seek(to time: TimeInterval) {
        seekCallCount += 1
        currentTime = min(max(time, 0), duration)
    }
}
