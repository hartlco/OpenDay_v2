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

    var showsLocationSearchView = false

    var entryTagState: EntryTagState
    var entryImagesState: EntryImagesState
    var locationSearchViewState: LocationSearchViewState
}
