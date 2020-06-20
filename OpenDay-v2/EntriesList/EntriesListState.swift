import Foundation
import Models
import ComposableArchitecture

struct EntriesListState: Equatable {
    var sections: [EntriesSection]
    var selection: Identified<Entry?, EntryState?>?

    var detailState = EntryState.empty()
    var showsAddEntry = false
}
