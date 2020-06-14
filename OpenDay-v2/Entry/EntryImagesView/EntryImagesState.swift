import Foundation
import Models
import CoreLocation

struct EntryImagesState: Equatable {
    var images: [ImageResource]

    var isShowingImagePicker = false
    var isShowingImageDatePopup = false

    var locationOfLastAddedImage: CLLocation?
    var dateOfLastAddedImage: Date?
}
