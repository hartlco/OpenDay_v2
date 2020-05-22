import Foundation
import Models
import ComposableArchitecture

struct EntryState: Equatable {
    var entry: Entry?

    var title: String
    var body: String
    var date: Date
    var currentLocation: Location?
    var weather: Weather?
}
