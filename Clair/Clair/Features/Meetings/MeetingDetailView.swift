import Foundation
import SwiftData
import SwiftUI

struct MeetingDetailView: View {
    @Environment(\.modelContext) private var modelContext

    @Bindable var meeting: Meeting

    @State private var recordingService = AVAudioRecordingService()
    @State private var recordingState: MeetingRecordingState = .idle
    @State private var errorMessage: String?
    @State private var isShowingError = false
    @State private var showsOverwriteConfirmation = false
    @State private var audioPlayer = MeetingAudioPlayerController(
        service: AVAudioPlaybackService()
    )

    private let audioFileStore = AudioFileStore()

    var body: some View {
        Form {
            meetingInformationSection
            recordingSection
            savedAudioSection
            meetingAudioPlayer
        }
        .task(
            id: "\(meeting.id.uuidString)|\(meeting.audioFilePath ?? "")",
            {
                audioPlayer.load(path: resolvedAudioURL?.path)
            }
        )
        .onDisappear {
            audioPlayer.stop()
        }
        .formStyle(.grouped)
        .padding()
        .confirmationDialog(
            "Replace the existing recording?",
            isPresented: $showsOverwriteConfirmation
        ) {
            Button("Replace Recording", role: .destructive) {
                requestPermissionAndStart()
            }

            Button("Cancel", role: .cancel) {}
        } message: {
            Text("The current audio file for this meeting will be replaced.")
        }
        .alert(
            "Audio Recording Error",
            isPresented: $isShowingError,
            presenting: errorMessage
        ) { _ in
            Button("OK", role: .cancel) {
                recordingState = .idle
            }
        } message: { message in
            Text(message)
        }
    }

    // MARK: - Sections

    private var meetingAudioPlayer: some View {
        VStack(alignment: .leading, spacing: 12) {
            if case let .failed(message) = audioPlayer.state {
                Label(message, systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)

                Button(
                    "Reload",
                    systemImage: "arrow.clockwise",
                    action: reloadAudio
                )
                .disabled(isAudioPlayerDisabled)
            }

            HStack {
                Button(
                    audioPlayer.state == .playing ? "Pause" : "Play",
                    systemImage: audioPlayer.state == .playing
                        ? "pause.fill"
                        : "play.fill"
                ) { audioPlayer.togglePlayback() }
                .keyboardShortcut(.space, modifiers: [])

                Button("Restart", systemImage: "backward.end.fill") {
                    audioPlayer.seek(to: 0)
                }
                .keyboardShortcut("r", modifiers: [.command])
            }
            .disabled(arePlaybackControlsDisabled)

            Slider(
                value: Binding(
                    get: { audioPlayer.currentTime },
                    set: { audioPlayer.seek(to: $0) }
                ),
                in: 0...max(audioPlayer.duration, 1)
            )
            .accessibilityLabel("Playback position")
            .accessibilityValue(
                "\(audioPlayer.currentTime.formattedClockTime()) sur \(audioPlayer.duration.formattedClockTime())"
            )
            .disabled(arePlaybackControlsDisabled)

            Text(
                "\(audioPlayer.currentTime.formattedClockTime()) / \(audioPlayer.duration.formattedClockTime())"
            )
                .monospacedDigit()
                .foregroundStyle(.secondary)
        }
    }

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
                    Text(duration.formattedClockTime())
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
            case .idle, .failed:
                idleRecordingContent

            case .requestingPermission:
                ProgressView("Requesting microphone access…")

            case .recording(let startedAt):
                activeRecordingContent(startedAt: startedAt)

            case .saving:
                ProgressView("Saving recording…")
            }
        }
    }

    private var idleRecordingContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("No recording in progress.")
                .foregroundStyle(.secondary)

            Button(
                "Start Recording",
                systemImage: "record.circle",
                action: prepareToStartRecording
            )
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
                    Text(elapsed.formatted())
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
        if let audioFilePath = meeting.audioFilePath,
            let resolvedAudioURL
        {
            Section("Saved Audio") {
                LabeledContent("File") {
                    Text(resolvedAudioURL.lastPathComponent)
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
    
    private var arePlaybackControlsDisabled: Bool {
        switch audioPlayer.state {
        case .ready, .playing, .paused:
            isAudioPlayerDisabled

        case .idle, .failed:
            true
        }
    }
    
    private var resolvedAudioURL: URL? {
        guard let audioFilePath = meeting.audioFilePath else {
            return nil
        }

        if audioFilePath.hasPrefix("/") {
            return URL(fileURLWithPath: audioFilePath)
        }

        return audioFileStore.fileURL(for: audioFilePath)
    }

    private func reloadAudio() {
        audioPlayer.load(path: resolvedAudioURL?.path)
    }

    private func prepareToStartRecording() {
        audioPlayer.stop()

        if meeting.audioFilePath == nil {
            requestPermissionAndStart()
        } else {
            showsOverwriteConfirmation = true
        }
    }

    private func requestPermissionAndStart() {
        recordingState = .requestingPermission

        Task {
            let permissionGranted = await recordingService.requestPermission()

            guard permissionGranted else {
                presentRecordingError(AudioRecordingError.permissionDenied)
                return
            }

            startRecording()
        }
    }

    private func startRecording() {
        do {
            try recordingService.startRecording(meetingID: meeting.id)

            let startedAt = Date.now

            meeting.startedAt = startedAt
            meeting.endedAt = nil
            meeting.duration = nil
            meeting.updatedAt = startedAt

            try modelContext.save()

            recordingState = .recording(startedAt: startedAt)
        } catch {
            presentRecordingError(error)
        }
    }

    private func stopRecording() {
        recordingState = .saving

        do {
            let recordedAudio = try recordingService.stopRecording()
            let finishedAt = Date.now

            meeting.audioFilePath = audioFileStore.relativePath(
                for: recordedAudio.fileURL
            )
            meeting.duration = recordedAudio.duration
            meeting.endedAt = finishedAt
            meeting.updatedAt = finishedAt

            try modelContext.save()

            recordingState = .idle
        } catch {
            presentRecordingError(error)
        }
    }

    private var isAudioPlayerDisabled: Bool {
        switch recordingState {
        case .idle, .failed:
            false

        case .requestingPermission, .recording, .saving:
            true
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

    private func presentRecordingError(_ error: Error) {
        recordingState = .failed(message: error.localizedDescription)
        presentError(error)
    }
}
