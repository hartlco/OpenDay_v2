import Foundation
import ComposableArchitecture
import WeatherService

let entriesListReducer = Reducer<EntriesListState,
    EntriesListAction,
EntriesListEnviornment>.combine(
    Reducer { state, action, enviornment in
            switch action {
            case .loadingTriggered:
                return enviornment.service
                    .entries
                    .receive(on: enviornment.mainQueue)
                    .catchToEffect()
                    .map(EntriesListAction.entriesResponse)
            case let .entriesResponse(.success(sections)):
                state.sections = sections
                return .none
            case let .entriesResponse(.failure(sections)):
                state.sections = []
                return .none
            case .delete(let entry):
                return enviornment.service
                    .deleteEntry(entry)
                    .catchToEffect()
                    .map { _ in
                        return EntriesListAction.loadingTriggered
                    }
            case .setNavigation(let entry):
                if let newEntry = entry {
                    let entryState = EntryState.from(entry: newEntry)
                    state.detailState = entryState
                    state.selection = Identified(entryState, id: newEntry)
                } else {
                    state.selection = nil
                }

                return .none
            case .showAddEntry(let value):
                state.detailState = EntryState.empty()
                state.showsAddEntry = value

                return .none
            case .entry:
                return .none
        }
    },
    entryReducer
        .pullback(
            state: \EntriesListState.detailState,
            action: /EntriesListAction.entry,
            environment: {
                $0.entryEnviornment
        }
    )
)
