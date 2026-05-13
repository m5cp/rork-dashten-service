import SwiftUI

struct VAFundingFeeCalculatorView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Coming soon")
                    .font(.headline.weight(.bold))
                Text("The VA Funding Fee calculator will be available shortly.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("VA Funding Fee")
        .navigationBarTitleDisplayMode(.inline)
    }
}
