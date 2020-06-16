import Foundation
import ComposableArchitecture

let tabReducer = Reducer<TabState, TabAction, TabEnviornment>.combine(
    Reducer { state, action, _ in
        switch action {
        case .setSelection(let tab):

            state.selection = Identified(tab, id: tab)
            return .none
        case .entryList(let action):
            switch action {
            case let .entriesResponse(.success(sections)):
                state.mapViewState.entries = sections.flatMap {
                    return $0.entries
                }
                state.mapViewState.locations = state.mapViewState.entries.compactMap {
                    $0.location
                }
                return .none
            default:
                return .none
            }
        case .mapViewAction(let action):
            return .none
        }
    },
    entriesListReducer.pullback(state: \TabState.entriesState,
                                action: /TabAction.entryList,
                                environment: {
                                    return $0.entriesListEnviornment
    }),
    mapViewReducer.pullback(state: \TabState.mapViewState,
                            action: /TabAction.mapViewAction,
                            environment: {
                                return $0.mapViewEnviornment
    })
)
