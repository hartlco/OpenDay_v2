import SwiftUI
import ComposableArchitecture

struct TabView: View {
    let store: Store<TabState, TabAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            SwiftUI.TabView(selection: viewStore.binding(
                get: { ($0.selection?.id ?? .entries) },
              send: TabAction.setSelection
            )) {
                EntriesListView(store: self.store.scope(
                    state: { $0.entriesState },
                    action: TabAction.entryList))
                    .tabItem {
                        Image(systemName: "house")
                        Text("Entries")
                }
                .tag(TabState.Tab.entries)
                Text("Two")
                    .tabItem {
                        Image(systemName: "map")
                        Text("Map")
                }
                .tag(TabState.Tab.map)
            }
        }
    }
}
