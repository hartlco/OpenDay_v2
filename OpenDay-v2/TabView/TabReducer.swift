import Foundation
import ComposableArchitecture

let tabReducer = Reducer<TabState, TabAction, TabEnviornment>.combine(
    Reducer { state, action, enviornment in
        switch action {
        case .setSelection(let tab):

            state.selection = Identified(tab, id: tab)
            return .none
        case .entryList:
            return .none
        }
    },
    entriesListReducer.pullback(state: \TabState.entriesState,
                                action: /TabAction.entryList,
                                environment: {
                                    return $0.entriesListEnviornment
    })

)
