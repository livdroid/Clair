//
//  MainWindowView.swift
//  Clair
//
//  Created by olivia on 11/06/2026.
//
import SwiftUI

struct MainWindowView: View {
    var body: some View {
        NavigationSplitView {
            DocumentSidebarView()
        } content: {
            MarkdownEditorView()
        } detail: {
            AnalysisInspectorView()
        }
        .navigationTitle("Clair")
    }
}

#Preview {
    MainWindowView()
}
