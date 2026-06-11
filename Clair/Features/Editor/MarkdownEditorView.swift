//
//  MarkdownEditorView.swift
//  Clair
//
//  Created by olivia on 11/06/2026.
//

import SwiftUI

struct MarkdownEditorView: View {
    @State private var text = """
        Article example
        """
    var body: some View {
        TextEditor(text: $text)
            .font(.system(.body, design: .monospaced))
            .padding()
            .navigationTitle("Editor")
    }
}

#Preview {
    MarkdownEditorView()
}
