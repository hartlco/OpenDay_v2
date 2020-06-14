import SwiftUI
import ComposableArchitecture
import MapView

struct MapEntryView: View {
    let store: Store<MapViewState, MapViewAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                MapView(locations: viewStore.binding(
                    get: { $0.locations },
                    send: MapViewAction.locationsChanged
                ),
                didSelect: { location in
                    viewStore.send(.didSelectLocation(location))
                })
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea([.top, .bottom])
                .navigationBarTitle(Text("Map"))
                .navigationBarItems(trailing:
                NavigationLink(destination: IfLetStore(
                    self.store.scope(
                        state: { $0.detailEntryState },
                        action: MapViewAction.entryAction),
                    then: EntryView.init(store:),
                    else: Text("Test")
                ), isActive: viewStore.binding(
                    get: { $0.showsDetail },
                    send: MapViewAction.showsDetail
                )) {
                    EmptyView()
                })
            }
        }
    }
}
