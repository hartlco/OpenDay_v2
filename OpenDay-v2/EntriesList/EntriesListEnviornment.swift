import Foundation
import ComposableArchitecture
import OpenDayService
import LocationService

struct EntriesListEnviornment {
    var service: OpenDayService
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var locationServcie: LocationService
}
