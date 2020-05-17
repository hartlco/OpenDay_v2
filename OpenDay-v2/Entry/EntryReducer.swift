import ComposableArchitecture

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

