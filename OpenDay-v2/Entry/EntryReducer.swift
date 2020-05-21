import ComposableArchitecture

let entryReducer = Reducer<EntryState, EntryAction, EntryEnviornment> {
    state, action, enviornment in
    switch action {
    case .updated:
        return .none
    case .updateTitle(let text):
        state.title = text
        return .none
    case .updateBody(let text):
        state.body = text
        return .none
    case .updateEntryIfNeeded:
        guard let entry = state.entry else {
            return .none
        }

        return enviornment
            .service
            .update(entry: entry,
                    title: state.title,
                    location: state.currentLocation)
        .catchToEffect()
        .map { _ in
            return .updated
        }
    case .loadLocation:
        return enviornment.locationService
            .getLocation()
            .receive(on: enviornment.mainQueue)
            .catchToEffect()
            .map(EntryAction.currentLocationChanged)
    case .currentLocationChanged(let result):
        switch result {
        case .success(let location):
            state.currentLocation = location
        case .failure:
            state.currentLocation = nil
        }

        return .none
    }
}

