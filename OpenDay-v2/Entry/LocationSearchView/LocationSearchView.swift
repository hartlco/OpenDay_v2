import Foundation
import SwiftUI
import ComposableArchitecture

struct LocationSearchView: View {
    let store: Store<LocationSearchViewState, LocationSearchAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            TextField(
              "Search Location",
              text: viewStore.binding(get: { $0.searchText },
                                      send: LocationSearchAction.searchTextChanged),
              onCommit: { viewStore.send(.search) }
            )
            ForEach(viewStore.locations) { location in
                Button(action: {
                    viewStore.send(.selectLocation(location))
                }, label: {
                    Text(location.localizedString())
                })
            }
        }
    }
}
