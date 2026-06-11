//
//  DocumentSidebarView.swift
//  Clair
//
//  Created by olivia on 11/06/2026.
//

import SwiftUI

struct DocumentSidebarView: View {
    var body: some View {
        List {
            Section("Library") {
                Label("Drafts", systemImage: "doc.text")
                Label("Articles", systemImage: "folder")
                Label("Needs Review", systemImage: "exclamationmark.triangle")
            }
        }
    }
}

#Preview {
    DocumentSidebarView()
}
