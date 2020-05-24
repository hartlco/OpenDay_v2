// Adapter from https://github.com/AlanQuatermain/AQUI/blob/master/Sources/AQUI/TextView.swift
//swiftlint:disable file_length
import SwiftUI
import Combine
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

@available (macOS 10.15, iOS 13, *)
@available (tvOS, unavailable)
@available (watchOS, unavailable)
private struct JustifiedTextEnvironmentKey: EnvironmentKey {
    typealias Value = Bool
    static var defaultValue: Bool = false
}

@available (macOS 10.15, iOS 13, *)
@available (tvOS, unavailable)
@available (watchOS, unavailable)
fileprivate extension EnvironmentValues {
    var justifiedText: Bool {
        get { self[JustifiedTextEnvironmentKey.self] }
        set { self[JustifiedTextEnvironmentKey.self] = newValue }
    }
}

private func _alignment(from environment: EnvironmentValues) -> NSTextAlignment {
    switch environment.multilineTextAlignment {
    case .center:
        return .center
    case .leading where environment.layoutDirection == .leftToRight:
        return .left
    case .leading where environment.layoutDirection == .rightToLeft:
        return .right
    case .trailing where environment.layoutDirection == .leftToRight:
        return .right
    case .trailing where environment.layoutDirection == .rightToLeft:
        return .left
    default:
        return environment.justifiedText ? .justified : .natural
    }
}

private struct TextDidChangePublisherKey: EnvironmentKey {
    typealias Value = PassthroughSubject<Bool, Never>?
    static var defaultValue: PassthroughSubject<Bool, Never>?
}
private struct TextDidCommitPublisherKey: EnvironmentKey {
    typealias Value = PassthroughSubject<Void, Never>?
    static var defaultValue: PassthroughSubject<Void, Never>?
}

fileprivate extension EnvironmentValues {
    var textDidChangePublisher: PassthroughSubject<Bool, Never>? {
        get { self[TextDidChangePublisherKey.self] }
        set { self[TextDidChangePublisherKey.self] = newValue }
    }
    var textDidCommitPublisher: PassthroughSubject<Void, Never>? {
        get { self[TextDidCommitPublisherKey.self] }
        set { self[TextDidCommitPublisherKey.self] = newValue }
    }
}

@available (macOS 10.15, iOS 13, *)
@available (tvOS, unavailable)
@available (watchOS, unavailable)
public struct TextView: View {
    #if canImport(UIKit)
    private typealias _PlatformView = _UIKitTextView
    #else
    private typealias _PlatformView = _AppKitTextView
    #endif

    private let platform: _PlatformView

    public init(text: Binding<String>) {
        self.platform = _PlatformView(text: text)
    }

    public var body: some View { platform }

    public func justified() -> some View {
        environment(\.justifiedText, true)
    }
}

private struct SubjectSinkView<Output, Content: View>: View {
    typealias Publisher = PassthroughSubject<Output, Never>
    let subject: AnyPublisher<Output, Never>
    var cancellable: Set<AnyCancellable> = []
    let body: AnyView

    init(_ body: Content,
         keyPath: WritableKeyPath<EnvironmentValues, Publisher?>,
         perform action: ((Output) -> Void)?) {
        if let action = action {
            let subject = Publisher()
            self.subject = AnyPublisher(subject)
            self.body = AnyView(body.environment(keyPath, subject))
            subject.sink(receiveValue: action)
                .store(in: &cancellable)
        } else {
            self.subject = AnyPublisher(Empty(completeImmediately: false))
            self.body = AnyView(body)
        }
    }
}

// This bit of syntactic sugar is needed because (() -> Void) doesn't map ((Void) -> Void),
// and ((Void) -> Void) generates a warning that as of Swift 4 you need to use () -> Void instead.
extension SubjectSinkView where Output == Void {
    init(_ body: Content, keyPath: WritableKeyPath<EnvironmentValues, Publisher?>, perform action: (() -> Void)?) {
        if let action = action {
            let subject = Publisher()
            self.subject = AnyPublisher(subject)
            self.body = AnyView(body.environment(keyPath, subject))
            subject.sink(receiveValue: action)
                .store(in: &cancellable)
        } else {
            self.subject = AnyPublisher(Empty(completeImmediately: false))
            self.body = AnyView(body)
        }
    }
}

@available (macOS 10.15, iOS 13, *)
@available (tvOS, unavailable)
@available (watchOS, unavailable)
public extension View {
    func onTextChanged(perform action: ((Bool) -> Void)?) -> some View {
        SubjectSinkView(self, keyPath: \.textDidChangePublisher, perform: action)
    }
    func onTextEditCommit(perform action: (() -> Void)?) -> some View {
        SubjectSinkView(self, keyPath: \.textDidCommitPublisher, perform: action)
    }
}

#if canImport(UIKit)
@available (iOS 13, *)
@available (macOS, unavailable)
@available (tvOS, unavailable)
@available (watchOS, unavailable)
extension UIContentSizeCategory {
    //swiftlint:disable cyclomatic_complexity
    fileprivate init(_ swiftuiValue: ContentSizeCategory) {
        switch swiftuiValue {
        case .extraSmall:
            self = .extraSmall
        case .small:
            self = .small
        case .medium:
            self = .medium
        case .large:
            self = .large
        case .extraLarge:
            self = .extraLarge
        case .extraExtraLarge:
            self = .extraExtraLarge
        case .extraExtraExtraLarge:
            self = .extraExtraExtraLarge
        case .accessibilityMedium:
            self = .accessibilityMedium
        case .accessibilityLarge:
            self = .accessibilityLarge
        case .accessibilityExtraLarge:
            self = .accessibilityExtraLarge
        case .accessibilityExtraExtraLarge:
            self = .accessibilityExtraExtraLarge
        case .accessibilityExtraExtraExtraLarge:
            self = .accessibilityExtraExtraExtraLarge
        @unknown default:
            self = .unspecified
        }
    }
}

@available (iOS 13, *)
@available (macOS, unavailable)
@available (tvOS, unavailable)
@available (watchOS, unavailable)
extension UITraitCollection {
    fileprivate convenience init(swiftUIContentSizeCategory value: ContentSizeCategory) {
        self.init(preferredContentSizeCategory: UIContentSizeCategory(value))
    }
}

@available (iOS 13, *)
@available (macOS, unavailable)
@available (tvOS, unavailable)
@available (watchOS, unavailable)
private struct _UIKitTextView: UIViewRepresentable {
    @Binding var text: String
    @State var justified: Bool = false

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.delegate = context.coordinator
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.textColor = UIColor.label
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.textColor = .label

        let traits = UITraitCollection(traitsFrom: [
            uiView.traitCollection,
            UITraitCollection(swiftUIContentSizeCategory: context.environment.sizeCategory)
        ])

        uiView.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: traits)
        uiView.textAlignment = _alignment(from: context.environment)

        context.coordinator.change = context.environment.textDidChangePublisher
        context.coordinator.commit = context.environment.textDidCommitPublisher
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: _UIKitTextView
        var change: PassthroughSubject<Bool, Never>?
        var commit: PassthroughSubject<Void, Never>?

        init(_ parent: _UIKitTextView) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            change?.send(true)
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            commit?.send()
            change?.send(false)
        }
    }
}
#else
@available (macOS 10.15, *)
@available (iOS, unavailable)
@available (tvOS, unavailable)
@available (watchOS, unavailable)
private struct _AppKitTextView: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSTextView {
        let view = NSTextView()
        view.delegate = context.coordinator
        view.textColor = .controlTextColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoresizingMask = [.width, .height]

        return view
    }

    func updateNSView(_ view: NSTextView, context: Context) {
        view.string = text

        if let lineLimit = context.environment.lineLimit {
            view.textContainer?.maximumNumberOfLines = lineLimit
        }

        view.alignment = _alignment(from: context.environment)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: _AppKitTextView
        var change: PassthroughSubject<Bool, Never>?
        var commit: PassthroughSubject<Void, Never>?

        init(_ parent: _AppKitTextView) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let text = notification.object as? NSText else { return }
            self.parent.text = text.string
        }

        func textDidBeginEditing(_ notification: Notification) {
            change?.send(true)
        }

        func textDidEndEditing(_ notification: Notification) {
            commit?.send()
            change?.send(false)
        }
    }
}
#endif

#if os(iOS)
public struct ExpandingTextView: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String

    var minHeight: CGFloat
    @Binding var calculatedHeight: CGFloat

    public init(placeholder: String,
                text: Binding<String>,
                minHeight: CGFloat,
                calculatedHeight: Binding<CGFloat>) {
        self.placeholder = placeholder
        self._text = text
        self.minHeight = minHeight
        self._calculatedHeight = calculatedHeight
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator

        // Decrease priority of content resistance, so content would not push external layout set in SwiftUI
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.font = .preferredFont(forTextStyle: .body)

        if text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.placeholderText
        } else {
            textView.text = text
            textView.textColor = UIColor.label
        }

        return textView
    }

    public func updateUIView(_ textView: UITextView, context: Context) {
        if textView.text != self.text, !text.isEmpty {
            textView.text = self.text
        }

        recalculateHeight(view: textView)
    }

    func recalculateHeight(view: UIView) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if minHeight < newSize.height && $calculatedHeight.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                self.$calculatedHeight.wrappedValue = newSize.height // !! must be called asynchronously
            }
        } else if minHeight >= newSize.height && $calculatedHeight.wrappedValue != minHeight {
            DispatchQueue.main.async {
                self.$calculatedHeight.wrappedValue = self.minHeight // !! must be called asynchronously
            }
        }
    }

    public class Coordinator: NSObject, UITextViewDelegate {
        var parent: ExpandingTextView

        init(_ uiTextView: ExpandingTextView) {
            self.parent = uiTextView
        }

        public func textViewDidChange(_ textView: UITextView) {
            // This is needed for multistage text input (eg. Chinese, Japanese)
            if textView.markedTextRange == nil {
                parent.text = textView.text ?? String()
                parent.recalculateHeight(view: textView)
            }
        }

        public func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.placeholderText {
                textView.text = nil
                textView.textColor = UIColor.label
            }
        }

        public func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = UIColor.placeholderText
            }
        }
    }
}

#endif
