import Foundation
import ComposableArchitecture

typealias MapViewReducer = Reducer<MapViewState, MapViewAction, MapViewEnviornment>

let mapViewReducer = MapViewReducer.combine(
    Reducer  { state, action, _ in
        switch action {
        case .didSelectLocation(let location):
            guard let entry = state.entries.first(where: {
                location == $0.location
            }) else {
                return .none
            }

            let entryState = EntryState.from(entry: entry)
            state.detailEntryState = entryState
            state.showsDetail = true
            return .none
        case .showsDetail(let value):
            state.showsDetail = false
            if !value {
                state.detailEntryState = nil
            }

            return .none
        default:
            return .none
        }
    },
    entryReducer
        .optional
        .pullback(
            state: \MapViewState.detailEntryState,
            action: /MapViewAction.entryAction,
            environment: {
                $0.entryEnviornment
        }
    )
)
