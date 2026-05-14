import SwiftUI

// Caps content at a comfortable reading width on iPad/large screens while
// keeping iPhone layouts untouched. Apply to the top-level VStack inside
// a tool/guide ScrollView.
extension View {
    func readableContentWidth(_ max: CGFloat = 720) -> some View {
        self.frame(maxWidth: max)
            .frame(maxWidth: .infinity)
    }
}
