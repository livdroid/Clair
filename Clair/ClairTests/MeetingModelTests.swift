//
//  MeetingModelTests.swift
//  ClairTests
//
//  Created by olivia on 18/06/2026.
//

import XCTest
import SwiftData
@testable import Clair

@MainActor
final class MeetingModelTests: XCTestCase {
    func testCreateMeetingPersistsInContext() throws {
        let container = try SwiftDataTestSupport.makeInMemoryContainer()
        let context = container.mainContext

        let meeting = Meeting(title: "Réunion test")
        context.insert(meeting)
        try context.save()

        let meetings = try context.fetch(FetchDescriptor<Meeting>())

        XCTAssertEqual(meetings.count, 1)
        XCTAssertEqual(meetings.first?.title, "Réunion test")
    }

    @MainActor
    func testUpdateMeetingTitle() throws {
        let container = try SwiftDataTestSupport.makeInMemoryContainer()
        let context = container.mainContext
        
        let meeting = Meeting(title: "Ancien titre")
        context.insert(meeting)
        try context.save()
        
        meeting.title = "Nouveau titre"
        meeting.updatedAt = .now
        try context.save()
        
        let meetings = try context.fetch(FetchDescriptor<Meeting>())
        
        XCTAssertEqual(meetings.first?.title, "Nouveau titre")
    }
    
    @MainActor
    func testDeleteMeetingRemovesItFromContext() throws {
        let container = try SwiftDataTestSupport.makeInMemoryContainer()
        let context = container.mainContext
        
        let meeting = Meeting(title: "À supprimer")
        context.insert(meeting)
        try context.save()
        
        context.delete(meeting)
        try context.save()
        
        let meetings = try context.fetch(FetchDescriptor<Meeting>())
        
        XCTAssertTrue(meetings.isEmpty)
    }
    
    @MainActor
    func testMeetingDefaultValues() throws {
        let meeting = Meeting(title: "Réunion test")

        XCTAssertEqual(meeting.title, "Réunion test")
        XCTAssertTrue(meeting.participants.isEmpty)
        XCTAssertTrue(meeting.transcriptSegments.isEmpty)
        XCTAssertTrue(meeting.actionItems.isEmpty)
        XCTAssertTrue(meeting.shortSummary.isEmpty)
        XCTAssertTrue(meeting.decisions.isEmpty)
        XCTAssertTrue(meeting.openQuestions.isEmpty)
        XCTAssertNil(meeting.audioFilePath)
    }

    func testAudioMetadataPersistsOnMeeting() throws {
        let container = try SwiftDataTestSupport.makeInMemoryContainer()
        let context = container.mainContext
        let meeting = Meeting(title: "Réunion audio")
        context.insert(meeting)

        meeting.audioFilePath = "Recordings/test.m4a"
        meeting.duration = 42
        meeting.startedAt = Date(timeIntervalSince1970: 100)
        meeting.endedAt = Date(timeIntervalSince1970: 142)
        meeting.updatedAt = Date(timeIntervalSince1970: 142)
        try context.save()

        let fetchedMeeting = try XCTUnwrap(
            context.fetch(FetchDescriptor<Meeting>()).first
        )

        XCTAssertEqual(fetchedMeeting.audioFilePath, "Recordings/test.m4a")
        XCTAssertEqual(fetchedMeeting.duration, 42)
        XCTAssertEqual(
            fetchedMeeting.startedAt,
            Date(timeIntervalSince1970: 100)
        )
        XCTAssertEqual(
            fetchedMeeting.endedAt,
            Date(timeIntervalSince1970: 142)
        )
    }
}
