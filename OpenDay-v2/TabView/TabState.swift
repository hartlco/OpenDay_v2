import ComposableArchitecture

struct TabState: Equatable {
    enum Tab: Hashable {
        case entries
        case map
    }

    var selection: Identified<Tab?, Tab?>?
    var entriesState = EntriesListState(sections: [])
    var mapViewState = MapViewState(entries: [], locations: [])
}
