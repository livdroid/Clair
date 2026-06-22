import XCTest
@testable import Clair

final class AudioFileStoreTests: XCTestCase {
    func testRecordingURLUsesMeetingIdentifierAndM4AExtension() {
        let meetingID = UUID()
        let store = AudioFileStore()

        let url = store.recordingURL(for: meetingID)

        XCTAssertEqual(
            url.lastPathComponent,
            "\(meetingID.uuidString).m4a"
        )
    }

    func testRelativePathCanBeResolvedBackToFileURL() {
        let meetingID = UUID()
        let store = AudioFileStore()
        let originalURL = store.recordingURL(for: meetingID)

        let relativePath = store.relativePath(for: originalURL)
        let resolvedURL = store.fileURL(for: relativePath)

        XCTAssertEqual(relativePath, "Recordings/\(meetingID.uuidString).m4a")
        XCTAssertEqual(resolvedURL, originalURL)
    }
}
