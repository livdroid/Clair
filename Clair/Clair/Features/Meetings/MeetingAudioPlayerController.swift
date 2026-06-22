//
//  MeetingAudioPlayerController.swift
//  Clair
//
//  Created by olivia on 22/06/2026.
//


import Foundation
import Observation

@MainActor
@Observable
final class MeetingAudioPlayerController {
    enum State: Equatable {
        case idle
        case ready
        case playing
        case paused
        case failed(message: String)
    }

    private let service: any AudioPlaybackService
    private var progressTask: Task<Void, Never>?
    private var isLoaded = false

    private(set) var state: State = .idle
    private(set) var duration: TimeInterval = 0
    private(set) var currentTime: TimeInterval = 0

    init(service: any AudioPlaybackService) {
        self.service = service
    }
    
    func load(path: String?) {
        stop()
        isLoaded = false
        duration = 0

        guard let path else {
            state = .idle
            return
        }

        let url = URL(fileURLWithPath: path)

        guard FileManager.default.fileExists(atPath: url.path) else {
            state = .failed(
                message: AudioPlaybackError.fileNotFound.localizedDescription
            )
            return
        }

        do {
            try service.load(url: url)
            isLoaded = true
            duration = service.duration
            currentTime = 0
            state = .ready
        } catch {
            state = .failed(message: error.localizedDescription)
        }
    }
    
    func togglePlayback() {
        switch state {
        case .playing:
            service.pause()
            stopProgressUpdates()
            state = .paused

        case .ready, .paused:
            do {
                try service.play()
                state = .playing
                startProgressUpdates()
            } catch {
                state = .failed(message: error.localizedDescription)
            }

        case .idle, .failed:
            break
        }
    }

    func seek(to time: TimeInterval) {
        service.seek(to: time)
        currentTime = min(max(time, 0), duration)
    }

    func stop() {
        stopProgressUpdates()
        service.stop()
        currentTime = 0

        state = isLoaded ? .ready : .idle
    }
    
    private func startProgressUpdates() {
        progressTask?.cancel()

        progressTask = Task { [weak self] in
            while !Task.isCancelled {
                guard let self else { return }

                currentTime = service.currentTime

                if !service.isPlaying {
                    currentTime = service.currentTime
                    state = .ready
                    return
                }

                try? await Task.sleep(for: .milliseconds(250))
            }
        }
    }

    private func stopProgressUpdates() {
        progressTask?.cancel()
        progressTask = nil
    }
}
