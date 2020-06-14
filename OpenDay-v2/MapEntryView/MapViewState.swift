import Foundation
import Models

struct MapViewState: Equatable {
    var entries: [Entry]
    var locations: [Location]

    var showsDetail = false
    var detailEntryState: EntryState?
}
