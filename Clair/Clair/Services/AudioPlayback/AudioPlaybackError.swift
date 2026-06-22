//
//  AudioPlaybackError.swift
//  Clair
//
//  Created by olivia on 22/06/2026.
//

import Foundation

enum AudioPlaybackError: LocalizedError, Equatable {
    case missingAudioPath
    case fileNotFound
    case unreadableFile
    case playbackFailed
    
    var errorDescription: String? {
        switch self {
        case .missingAudioPath:
            return "No audio path provided"
        case .fileNotFound:
            return "File not found"
        case .unreadableFile:
            return "Unreadable file"
        case .playbackFailed:
            return "Playback failed"
        }
    }
}
