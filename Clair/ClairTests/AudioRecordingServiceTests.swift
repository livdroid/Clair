import XCTest
@testable import Clair

@MainActor
final class AudioRecordingServiceTests: XCTestCase {
    func testMockStartsAndStopsWithRecordedAudio() throws {
        let service = MockAudioRecordingService()

        try service.startRecording(meetingID: UUID())
        XCTAssertTrue(service.isRecording)

        let audio = try service.stopRecording()

        XCTAssertFalse(service.isRecording)
        XCTAssertEqual(audio.duration, 42)
    }

    func testMockCanRefusePermission() async {
        let service = MockAudioRecordingService()
        service.permissionGranted = false

        let granted = await service.requestPermission()

        XCTAssertFalse(granted)
        XCTAssertFalse(service.isRecording)
    }

    func testStartErrorIsPropagated() {
        let service = MockAudioRecordingService()
        service.startError = AudioRecordingError.unableToStart

        XCTAssertThrowsError(
            try service.startRecording(meetingID: UUID())
        ) { error in
            XCTAssertEqual(
                error as? AudioRecordingError,
                .unableToStart
            )
        }
        XCTAssertFalse(service.isRecording)
    }

    func testStopErrorIsPropagated() throws {
        let service = MockAudioRecordingService()
        try service.startRecording(meetingID: UUID())
        service.stopError = AudioRecordingError.notRecording

        XCTAssertThrowsError(try service.stopRecording()) { error in
            XCTAssertEqual(
                error as? AudioRecordingError,
                .notRecording
            )
        }
        XCTAssertTrue(service.isRecording)
    }
}
