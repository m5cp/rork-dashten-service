import SwiftUI

// Wrapper around the single source of truth in GuideContents.swift
// (CivilianPlaybookContent) so all surfaces show identical content.
struct CivilianPlaybookView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                CivilianPlaybookContent()
            }
            .readableContentWidth()
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Civilian Playbook")
        .navigationBarTitleDisplayMode(.inline)
    }
}
