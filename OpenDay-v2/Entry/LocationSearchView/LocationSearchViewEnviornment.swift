import Foundation
import LocationService
import ComposableArchitecture

struct LocationSearchViewEnviornment {
    let locationService: LocationService
    var mainQueue: AnySchedulerOf<DispatchQueue>
}
