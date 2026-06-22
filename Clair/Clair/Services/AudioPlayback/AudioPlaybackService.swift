//
//  AudioPlaybackService.swift
//  Clair
//
//  Created by olivia on 22/06/2026.
//

import Foundation

@MainActor
protocol AudioPlaybackService: AnyObject {
    var duration: TimeInterval { get }
    var currentTime: TimeInterval { get }
    var isPlaying: Bool { get }
    
    func load(url: URL) throws
    func play() throws
    func pause()
    func stop()
    func seek(to time: TimeInterval)
}
