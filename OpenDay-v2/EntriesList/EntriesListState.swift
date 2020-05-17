import Foundation
import Models
import ComposableArchitecture

struct EntriesListState: Equatable {
    var sections: [EntriesSection]
    var selection: Identified<Entry, EntryState>?
}

struct EntryState: Equatable {
    var entry: Entry?
    var title: String
    var body: String?
}

enum EntryAction: Equatable {
    case updateTitle(text: String)
    case updateEntryIfNeeded
    case updated
}

let entryReducer = Reducer<EntryState, EntryAction, EntryEnviornment> {
    state, action, enviornment in
    switch action {
    case .updated:
        return .none
    case .updateTitle(let text):
        state.title = text
        print("Updated title")
        return .none
    case .updateEntryIfNeeded:
        guard let entry = state.entry else {
            return .none
        }

        return enviornment
            .service
            .update(entry: entry, title: state.title)
        .catchToEffect()
        .map { _ in
            return .updated
        }
    }
}
