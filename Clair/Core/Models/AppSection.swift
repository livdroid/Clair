//
//  AppSection.swift
//  Clair
//
//  Created by olivia on 11/06/2026.
//

import Foundation

enum AppSection: String, CaseIterable, Identifiable, Sendable {
    case drafts
    case articles
    case needReview

    var id: String { rawValue }

    var title: String {
        switch self {
        case .drafts:
            "Drafts"
        case .articles:
            "Articles"
        case .needReview:
            "Need Review"
        }
    }
}
