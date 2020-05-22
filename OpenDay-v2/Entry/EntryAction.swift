import Foundation
import ComposableArchitecture
import Models
import WeatherService

enum EntryAction {
    case updateTitle(text: String)
    case updateBody(text: String)
    case updateDate(date: Date)
    case addImage(imageResource: ImageResource)
    case removeImage(imageResouce: ImageResource)
    case updateWeather(Result<WeatherService.WeatherData, Error>)
    case loadLocation
    case updateEntryIfNeeded
    case updated
    case currentLocationChanged(Result<Location, Error>)
}
