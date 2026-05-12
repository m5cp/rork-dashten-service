import SwiftUI
import UIKit
import ObjectiveC

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
/// Call `KeyboardAccessoryInstaller.install()` once on app launch.
enum KeyboardAccessoryInstaller {

    private static var didInstall = false

    static func install() {
        guard !didInstall else { return }
        didInstall = true

        swizzle(
            UITextField.self,
            original: #selector(UIView.didMoveToWindow),
            swizzled: #selector(UITextField.rork_didMoveToWindow)
        )
        swizzle(
            UITextView.self,
            original: #selector(UIView.didMoveToWindow),
            swizzled: #selector(UITextView.rork_didMoveToWindow)
        )

        installTapToDismiss()
    }

    private static func swizzle(_ cls: AnyClass, original: Selector, swizzled: Selector) {
        guard
            let originalMethod = class_getInstanceMethod(cls, original),
            let swizzledMethod = class_getInstanceMethod(cls, swizzled)
        else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

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

// MARK: - Swizzled implementations

extension UITextField {
    @objc fileprivate func rork_didMoveToWindow() {
        self.rork_didMoveToWindow() // calls original
        if window != nil, inputAccessoryView == nil, !rork_shouldSkipAccessory {
            inputAccessoryView = KeyboardAccessoryFactory.make(for: self)
        }
    }

    fileprivate var rork_shouldSkipAccessory: Bool {
        // Don't add to search bars or password fields handled by system UI.
        if isSecureTextEntry { return false } // still allow on secure fields
        // Skip if hosted inside a UISearchBar (system bar already has cancel).
        var v: UIView? = self.superview
        while let current = v {
            if NSStringFromClass(type(of: current)).contains("SearchBar") {
                return true
            }
            v = current.superview
        }
        return false
    }
}

extension UITextView {
    @objc fileprivate func rork_didMoveToWindow() {
        self.rork_didMoveToWindow() // calls original
        if window != nil, inputAccessoryView == nil {
            inputAccessoryView = KeyboardAccessoryFactory.make(for: self)
        }
    }
}

// MARK: - Accessory factory

private enum KeyboardAccessoryFactory {
    static func make(for responder: UIResponder) -> UIToolbar {
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
