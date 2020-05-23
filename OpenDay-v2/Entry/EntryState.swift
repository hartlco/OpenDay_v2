import Foundation
import Models
import CoreLocation
import ComposableArchitecture

struct EntryState: Equatable {
    var entry: Entry?

    var isShowingImagePicker = false
    var isShowingImageDatePopup = false

    var locationOfLastAddedImage: CLLocation?
    var dateOfLastAddedImage: Date?

    var title: String
    var body: String
    var date: Date
    var currentLocation: Location?
    var weather: Weather?
    var images: [ImageResource]
}
