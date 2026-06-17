//
//  SwiftDataTestSupport.swift
//  ClairTests
//
//  Created by olivia on 18/06/2026.
//

import Foundation
import SwiftData

@testable import Clair

@MainActor
enum SwiftDataTestSupport {
    static func makeInMemoryContainer() throws -> ModelContainer {

        let configuration = ModelConfiguration(
            isStoredInMemoryOnly: true
        )

        return try ModelContainer(
            for: Meeting.self,
            MeetingParticipant.self,
            TranscriptSegment.self,
            ActionItem.self,
            configurations: configuration
        )
    }

}
