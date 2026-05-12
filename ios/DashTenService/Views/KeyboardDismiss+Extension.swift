import SwiftUI
import UIKit

extension View {
    /// Adds a "Done" button above the keyboard that dismisses input,
    /// plus interactive scroll-to-dismiss support.
    func keyboardDoneToolbar() -> some View {
        self
            .scrollDismissesKeyboard(.interactively)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil
                        )
                    } label: {
                        Text("Done")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(AppTheme.forestGreen)
                    }
                    .accessibilityLabel("Close keyboard")
                }
            }
    }
}
