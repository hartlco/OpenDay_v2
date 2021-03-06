import CoreLocation
import ComposableArchitecture
import Models
import WeatherService

enum EntryAction {
    case updateTitle(text: String)
    case updateBody(text: String)
    case updateDate(date: Date)
    case updateWeather(Result<WeatherService.WeatherData, Error>)
    case loadLocation
    case showsLocationSearchView(Bool)
    case updateEntryIfNeeded
    case updated
    case currentLocationChanged(Result<Location, Error>)
    case tagAction(EntryTagAction)
    case imageAction(EntryImagesAction)
    case locationSearchAction(LocationSearchAction)
}
