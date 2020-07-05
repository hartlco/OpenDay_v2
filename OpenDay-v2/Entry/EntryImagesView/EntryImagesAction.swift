#if canImport(UIKit)
import UIKit
#endif
import CoreLocation
import Models

enum EntryImagesAction {
    case removeImage(ImageResource)
    case presentImagePicker(Bool)
    case imagePicked(image: UIImage, location: CLLocation?, date: Date?)
    case presentImageDatePopup(Bool)
    case useImageLocationDate
}
