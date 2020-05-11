import Foundation
import ComposableArchitecture
import OpenDayService

struct EntriesListEnviornment {
    var service: OpenDayService
    var mainQueue: AnySchedulerOf<DispatchQueue>
}
