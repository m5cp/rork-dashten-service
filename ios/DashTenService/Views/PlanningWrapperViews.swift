import SwiftUI

// Lightweight wrappers around the planning content structs in GuideContents.swift.
// Each presents the same content under a navigation title with consistent chrome.

struct CareerPlanningView: View {
    let storage: StorageService

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CareerPlanningContent()
            }
            .readableContentWidth()
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Career & Employment")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EducationPlanningView: View {
    let storage: StorageService

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                EducationPlanningContent()
            }
            .readableContentWidth()
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Education & Training")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FamilyPlanningView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                FamilyPlanningContent()
            }
            .readableContentWidth()
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Family & Move")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FinancialPlanningView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                FinancialPlanningContent()
            }
            .readableContentWidth()
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Financial Planning")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FirstThirtyDaysView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                FirstThirtyDaysContent()
            }
            .readableContentWidth()
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("First 30 Days")
        .navigationBarTitleDisplayMode(.inline)
    }
}
