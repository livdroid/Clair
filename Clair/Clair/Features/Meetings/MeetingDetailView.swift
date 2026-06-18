import Foundation
import SwiftUI
import SwiftData

struct MeetingDetailView: View {
    @Environment(\.modelContext) private var modelContext

    @Bindable var meeting: Meeting

    @State private var recordingService = AVAudioRecordingService()
    @State private var recordingState: RecordingState = .idle
    @State private var errorMessage: String?
    @State private var isShowingError = false

    var body: some View {
        Form {
            meetingInformationSection
            recordingSection
            savedAudioSection
        }
        .formStyle(.grouped)
        .padding()
        .alert(
            "Unable to Record",
            isPresented: $isShowingError,
            presenting: errorMessage
        ) { _ in
            Button("OK", role: .cancel) {}
        } message: { message in
            Text(message)
        }
    }

    // MARK: - Sections

    private var meetingInformationSection: some View {
        Section("Meeting Details") {
            TextField("Title", text: $meeting.title)
                .onSubmit {
                    saveMeetingChanges()
                }

            LabeledContent("Created") {
                Text(
                    meeting.createdAt.formatted(
                        date: .abbreviated,
                        time: .shortened
                    )
                )
            }

            if let duration = meeting.duration {
                LabeledContent("Recorded Duration") {
                    Text(formattedDuration(duration))
                }
            }

            Button("Save Changes") {
                saveMeetingChanges()
            }
        }
    }

    private var recordingSection: some View {
        Section("Recording") {
            switch recordingState {
            case .idle:
                idleRecordingContent

            case .starting:
                ProgressView("Preparing recording…")

            case .recording(let startedAt):
                activeRecordingContent(startedAt: startedAt)

            case .stopping:
                ProgressView("Finalizing recording…")
            }
        }
    }

    private var idleRecordingContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("No recording in progress.")
                .foregroundStyle(.secondary)

            Button {
                startRecording()
            } label: {
                Label("Start Recording", systemImage: "record.circle")
            }
        }
    }

    private func activeRecordingContent(startedAt: Date) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(.red)
                    .frame(width: 10, height: 10)

                Text("Recording in progress")
                    .fontWeight(.medium)
            }

            TimelineView(.periodic(from: .now, by: 1)) { timeline in
                let elapsed = timeline.date.timeIntervalSince(startedAt)

                LabeledContent("Current Duration") {
                    Text(formattedDuration(elapsed))
                        .monospacedDigit()
                }
            }

            Button(role: .destructive) {
                stopRecording()
            } label: {
                Label("Stop Recording", systemImage: "stop.circle")
            }
        }
    }

    @ViewBuilder
    private var savedAudioSection: some View {
        if let audioFilePath = meeting.audioFilePath {
            Section("Saved Audio") {
                LabeledContent("File") {
                    Text(URL(fileURLWithPath: audioFilePath).lastPathComponent)
                        .textSelection(.enabled)
                }

                LabeledContent("Path") {
                    Text(audioFilePath)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                }
            }
        }
    }

    // MARK: - Actions

    private func startRecording() {
        Task { @MainActor in
            recordingState = .starting

            do {
                try await recordingService.startRecording(meetingID: meeting.id)

                let startedAt = Date()

                meeting.startedAt = startedAt
                meeting.endedAt = nil
                meeting.updatedAt = startedAt

                try modelContext.save()

                recordingState = .recording(startedAt: startedAt)
            } catch {
                recordingState = .idle
                presentError(error)
            }
        }
    }

    private func stopRecording() {
        Task { @MainActor in
            recordingState = .stopping

            do {
                let recordedAudio = try recordingService.stopRecording()

                let finishedAt = Date()

                meeting.audioFilePath = recordedAudio.fileURL.path
                meeting.duration = recordedAudio.duration
                meeting.endedAt = finishedAt
                meeting.updatedAt = finishedAt

                try modelContext.save()

                recordingState = .idle
            } catch {
                recordingState = .idle
                presentError(error)
            }
        }
    }

    private func saveMeetingChanges() {
        meeting.updatedAt = .now

        do {
            try modelContext.save()
        } catch {
            presentError(error)
        }
    }

    private func presentError(_ error: Error) {
        errorMessage = error.localizedDescription
        isShowingError = true
    }

    // MARK: - Formatting

    private func formattedDuration(_ duration: TimeInterval) -> String {
        let totalSeconds = max(0, Int(duration.rounded()))

        let hours = totalSeconds / 3_600
        let minutes = (totalSeconds % 3_600) / 60
        let seconds = totalSeconds % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }

        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Recording State

private enum RecordingState {
    case idle
    case starting
    case recording(startedAt: Date)
    case stopping
}
