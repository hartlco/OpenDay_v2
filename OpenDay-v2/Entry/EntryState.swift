import Foundation
import Models
import CoreLocation
import ComposableArchitecture

struct EntryState: Equatable {
    var entry: Entry?

    var title: String
    var body: String
    var date: Date
    var currentLocation: Location?
    var weather: Weather?

    var entryTagState: EntryTagState
    var entryImagesState: EntryImagesState
}
