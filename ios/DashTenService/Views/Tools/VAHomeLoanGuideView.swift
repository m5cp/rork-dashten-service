import SwiftUI

struct VAHomeLoanGuideView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("Coming soon")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("VA Home Loan Guide")
        .navigationBarTitleDisplayMode(.inline)
    }
}
