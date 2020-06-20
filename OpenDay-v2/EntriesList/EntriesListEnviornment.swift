import Foundation
import ComposableArchitecture
import OpenDayService
import LocationService
import WeatherService

struct EntriesListEnviornment {
    var service: OpenDayService
    var mainQueue: AnySchedulerOf<DispatchQueue>

    let entryEnviornment: EntryEnviornment
}
