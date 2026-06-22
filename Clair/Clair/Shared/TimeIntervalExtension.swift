//
//  TimeIntervalExtension.swift
//  Clair
//
//  Created by olivia on 22/06/2026.
//


import Foundation

// MARK: - TimeInterval Formatting

extension TimeInterval {
    /// Formats the time interval as a clock time string (e.g., 1:05:09 or 5:07)
    func formattedClockTime() -> String {
        let totalSeconds = Int(self.rounded())
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
}
