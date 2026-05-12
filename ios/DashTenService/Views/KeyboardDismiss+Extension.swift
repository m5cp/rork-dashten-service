import SwiftUI
import UIKit

// MARK: - Public SwiftUI helpers

extension View {
    /// Adds interactive scroll-to-dismiss support for the keyboard.
    /// The "Done" button is installed app-wide via `KeyboardAccessoryInstaller`,
    /// so this modifier no longer needs to attach a SwiftUI toolbar (which
    /// silently fails inside sheets and inline forms).
    func keyboardDoneToolbar() -> some View {
        self.scrollDismissesKeyboard(.interactively)
    }
}

// MARK: - App-wide keyboard accessory

/// Installs a "Done" accessory bar above the keyboard for every UITextField
/// and UITextView in the app, plus a tap-to-dismiss gesture on the key window.
///
/// Implementation note: we previously swizzled `didMoveToWindow`, but
/// `class_getInstanceMethod` returns inherited methods, so the swap actually
/// happened on `UIView` itself and crashed the app on launch. Instead we now
/// observe the `textDidBeginEditing` notifications, which fire for every
/// `UITextField`/`UITextView` the moment the user taps into them — no
/// swizzling, no shared-class side effects.
enum KeyboardAccessoryInstaller {

    private static var didInstall = false

    @MainActor
    static func install() {
        guard !didInstall else { return }
        didInstall = true

        let center = NotificationCenter.default
        center.addObserver(
            KeyboardObserver.shared,
            selector: #selector(KeyboardObserver.textFieldDidBegin(_:)),
            name: UITextField.textDidBeginEditingNotification,
            object: nil
        )
        center.addObserver(
            KeyboardObserver.shared,
            selector: #selector(KeyboardObserver.textViewDidBegin(_:)),
            name: UITextView.textDidBeginEditingNotification,
            object: nil
        )

        installTapToDismiss()
    }

    @MainActor
    private static func installTapToDismiss() {
        // Slight delay so a window exists.
        DispatchQueue.main.async {
            guard
                let scene = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first,
                let window = scene.windows.first
            else { return }

            let tap = UITapGestureRecognizer(
                target: KeyboardTapTarget.shared,
                action: #selector(KeyboardTapTarget.dismiss)
            )
            tap.cancelsTouchesInView = false
            tap.requiresExclusiveTouchType = false
            tap.delegate = KeyboardTapTarget.shared
            window.addGestureRecognizer(tap)
        }
    }
}

// MARK: - Begin-editing observer

private final class KeyboardObserver: NSObject {
    static let shared = KeyboardObserver()

    @objc func textFieldDidBegin(_ note: Notification) {
        guard let field = note.object as? UITextField else { return }
        if field.inputAccessoryView != nil { return }
        if shouldSkip(field) { return }
        field.inputAccessoryView = KeyboardAccessoryFactory.make()
        field.reloadInputViews()
    }

    @objc func textViewDidBegin(_ note: Notification) {
        guard let view = note.object as? UITextView else { return }
        if view.inputAccessoryView != nil { return }
        view.inputAccessoryView = KeyboardAccessoryFactory.make()
        view.reloadInputViews()
    }

    private func shouldSkip(_ field: UITextField) -> Bool {
        // Skip text fields hosted inside a UISearchBar (system bar handles dismiss).
        var v: UIView? = field.superview
        while let current = v {
            if NSStringFromClass(type(of: current)).contains("SearchBar") {
                return true
            }
            v = current.superview
        }
        return false
    }
}

// MARK: - Tap-to-dismiss helper

private final class KeyboardTapTarget: NSObject, UIGestureRecognizerDelegate {
    static let shared = KeyboardTapTarget()

    @objc func dismiss() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer
    ) -> Bool {
        true
    }

    // Don't steal taps that land on interactive controls.
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        guard let view = touch.view else { return true }
        if view is UIControl { return false }
        if view is UITextInput { return false }
        // Walk up to find a UIControl ancestor (e.g. SwiftUI button host).
        var v: UIView? = view
        while let current = v {
            if current is UIControl { return false }
            v = current.superview
        }
        return true
    }
}

// MARK: - Accessory factory

private enum KeyboardAccessoryFactory {
    @MainActor
    static func make() -> UIToolbar {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        bar.barStyle = .default
        bar.isTranslucent = true
        bar.sizeToFit()

        let flexible = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        let done = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: KeyboardDoneTarget.shared,
            action: #selector(KeyboardDoneTarget.tapped)
        )
        // Forest green: #2D5A3F (matches AppTheme.forestGreen)
        done.tintColor = UIColor(red: 45.0/255.0, green: 90.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        done.setTitleTextAttributes(
            [.font: UIFont.systemFont(ofSize: 17, weight: .semibold)],
            for: .normal
        )
        done.setTitleTextAttributes(
            [.font: UIFont.systemFont(ofSize: 17, weight: .semibold)],
            for: .highlighted
        )

        bar.items = [flexible, done]
        bar.accessibilityLabel = "Keyboard toolbar"
        return bar
    }
}

private final class KeyboardDoneTarget: NSObject {
    static let shared = KeyboardDoneTarget()

    @objc func tapped() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
