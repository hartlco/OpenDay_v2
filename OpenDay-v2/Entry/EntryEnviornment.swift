import Foundation
import OpenDayService
import ComposableArchitecture
import LocationService

struct EntryEnviornment {
    var service: OpenDayService
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var locationService: LocationService
}
