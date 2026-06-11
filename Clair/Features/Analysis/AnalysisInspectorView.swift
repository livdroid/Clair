//
//  AnalysisInspectorView.swift
//  Clair
//
//  Created by olivia on 11/06/2026.
//

import SwiftUI

struct AnalysisInspectorView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Analysis Inspector")
                .font(Font.title2.weight(.semibold))
            Divider()
            AnalysisPlaceholderCard(
                title: "Reliability",
                value: "Not analyzed yet",
                systemImage: "checkmark.shield"
            )

            AnalysisPlaceholderCard(
                title: "Writing",
                value: "No suggestions yet",
                systemImage: "text.badge.checkmark"
            )

            AnalysisPlaceholderCard(
                title: "Sources",
                value: "No sources attached",
                systemImage: "link"
            )
            Spacer()
                .padding()
                .frame(minHeight: 260)
        }
    }
}

private struct AnalysisPlaceholderCard: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: systemImage)
                .font(.headline)

            Text(value)
                .font(.subheadline)
                .foregroundStyle(.secondary)

        }

        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))

    }
}

#Preview {
    AnalysisInspectorView()
}
