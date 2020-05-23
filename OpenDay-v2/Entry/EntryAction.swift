import UIKit
import CoreLocation
import ComposableArchitecture
import Models
import WeatherService

enum EntryAction {
    case updateTitle(text: String)
    case updateBody(text: String)
    case updateDate(date: Date)
    case addImage(ImageResource)
    case removeImage(ImageResource)
    case updateWeather(Result<WeatherService.WeatherData, Error>)
    case loadLocation
    case updateEntryIfNeeded
    case updated
    case currentLocationChanged(Result<Location, Error>)
    case presentImagePicker(Bool)
    case imagePicked(image: UIImage, location: CLLocation?, date: Date?)
    case presentImageDatePopup(Bool)
    case useImageLocationDate
}
