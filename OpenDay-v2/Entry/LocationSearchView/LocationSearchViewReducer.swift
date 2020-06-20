import Foundation
import ComposableArchitecture

typealias LocationSearchViewReducer = Reducer<
    LocationSearchViewState,
    LocationSearchAction,
    LocationSearchViewEnviornment
>

let locationSearchViewReducer = LocationSearchViewReducer { state, action, enviornment in
    switch action {
    case .search:
        let text = state.searchText
        state.searchText = ""

        return enviornment.locationService
            .getLocations(from: text)
            .receive(on: enviornment.mainQueue)
            .catchToEffect()
            .map(LocationSearchAction.locationsChanged)
    case .searchTextChanged(let value):
        state.searchText = value

        return .none
    case .locationsChanged(let .success(value)):
        state.locations = value
        return .none
    case .locationsChanged(.failure):
        state.locations = []
        return .none
    case .selectLocation(let location):
        state.searchText = ""
        state.locations = []

        return .none
    }
}
