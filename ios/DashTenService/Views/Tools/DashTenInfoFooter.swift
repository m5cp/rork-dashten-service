import SwiftUI

// ============================================================================
// DashTenInfoFooter
// ----------------------------------------------------------------------------
// One quiet line of informational fine print, used at the bottom of every
// tool screen. Replaces older, louder disclaimer banners.
// ============================================================================

struct DashTenInfoFooter: View {
    var body: some View {
        Text("General information only · Not affiliated with any government agency")
            .font(.caption2)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
    }
}

#Preview {
    DashTenInfoFooter()
        .padding()
}
