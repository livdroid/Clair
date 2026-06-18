//
//  AudioRecordingError.swift
//  Clair
//
//  Created by olivia on 19/06/2026.
//

import Foundation

enum AudioRecordingError: LocalizedError {
    case permissionDenied
    case alreadyRecording
    case notRecording
    case unableToCreateDirectory
    case unableToStart

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            "L’accès au microphone a été refusé."
        case .alreadyRecording:
            "Un enregistrement est déjà en cours."
        case .notRecording:
            "Aucun enregistrement n’est en cours."
        case .unableToCreateDirectory:
            "Clair ne peut pas créer son dossier d’enregistrement."
        case .unableToStart:
            "Clair ne peut pas démarrer l’enregistrement."
        }
    }
}
