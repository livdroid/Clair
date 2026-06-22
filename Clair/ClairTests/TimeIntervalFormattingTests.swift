//
//  TimeIntervalFormattingTests.swift
//  Clair
//
//  Created by olivia on 23/06/2026.
//


import XCTest
@testable import Clair

final class TimeIntervalFormattingTests: XCTestCase {
    func testDurationUnderOneHourUsesMinutesAndSeconds() {
        XCTAssertEqual(65.0.formattedClockTime(), "1:05")
    }

    func testDurationOverOneHourUsesHoursMinutesAndSeconds() {
        XCTAssertEqual(3_725.0.formattedClockTime(), "1:02:05")
    }

    func testZeroDuration() {
        XCTAssertEqual(0.0.formattedClockTime(), "0:00")
    }
}