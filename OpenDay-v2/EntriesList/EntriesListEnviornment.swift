import Foundation
import ComposableArchitecture
import OpenDayService
import LocationService
import WeatherService

struct EntriesListEnviornment {
    var service: OpenDayService
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var locationServcie: LocationService

    var entryEnviornment: EntryEnviornment {
        return EntryEnviornment(service: service,
                                mainQueue: mainQueue,
                                locationService: locationServcie,
                                weatherService: WeatherService(key: Secrets.weatherServiceSecret))
    }
}
