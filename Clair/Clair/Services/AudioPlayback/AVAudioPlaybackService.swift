//
//  AVAudioPlaybackService.swift
//  Clair
//
//  Created by olivia on 22/06/2026.
//


import AVFAudio
import Foundation

@MainActor
final class AVAudioPlaybackService: NSObject, AudioPlaybackService {
    private var player: AVAudioPlayer?

    var duration: TimeInterval { player?.duration ?? 0 }
    var currentTime: TimeInterval { player?.currentTime ?? 0 }
    var isPlaying: Bool { player?.isPlaying ?? false }

    func load(url: URL) throws {
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            self.player = player
        } catch {
            throw AudioPlaybackError.unreadableFile
        }
    }

    func play() throws {
        guard let player, player.play() else {
            throw AudioPlaybackError.playbackFailed
        }
    }

    func pause() {
        player?.pause()
    }

    func stop() {
        player?.stop()
        player?.currentTime = 0
    }

    func seek(to time: TimeInterval) {
        guard let player else { return }
        player.currentTime = min(max(time, 0), player.duration)
    }
}