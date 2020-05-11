import Foundation
import ComposableArchitecture

let entriesListReducer = Reducer<EntriesListState,
    EntriesListAction,
    EntriesListEnviornment> { state, action, enviornment in
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
        }
}
