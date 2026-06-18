//
//  AudioFileStore.swift
//  Clair
//
//  Created by olivia on 19/06/2026.
//


import Foundation

struct AudioFileStore {
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    var rootDirectory: URL {
        URL.applicationSupportDirectory
            .appending(path: "Clair", directoryHint: .isDirectory)
    }

    var recordingsDirectory: URL {
        rootDirectory
            .appending(path: "Recordings", directoryHint: .isDirectory)
    }

    func createRecordingsDirectoryIfNeeded() throws {
        try fileManager.createDirectory(
            at: recordingsDirectory,
            withIntermediateDirectories: true
        )
    }

    func recordingURL(for meetingID: UUID) -> URL {
        recordingsDirectory
            .appending(path: "\(meetingID.uuidString).m4a")
    }

    func relativePath(for fileURL: URL) -> String {
        "Recordings/\(fileURL.lastPathComponent)"
    }

    func fileURL(for relativePath: String) -> URL {
        rootDirectory.appending(path: relativePath)
    }
}
