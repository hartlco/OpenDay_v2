import Foundation
import Cocoa

typealias UIImage = NSImage

extension NSImage {
    var cgImage: CGImage? {
        var proposedRect = CGRect(origin: .zero, size: size)

        return cgImage(forProposedRect: &proposedRect,
                       context: nil,
                       hints: nil)
    }

    func jpegData(compressionQuality: CGFloat) -> Data? {
        // TODO: Provide implementation
        return nil
    }

    convenience init?(named name: String) {
        self.init(named: Name(name))
    }
}
