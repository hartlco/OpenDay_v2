import Foundation
import OpenDayService
import ComposableArchitecture
import LocationService
import WeatherService

struct EntryEnviornment {
    var service: OpenDayService
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var locationService: LocationService
    var weatherService: WeatherService

    var locationSearchEnviornment: LocationSearchViewEnviornment {
        LocationSearchViewEnviornment(locationService: locationService,
                                      mainQueue: mainQueue)
    }
}
