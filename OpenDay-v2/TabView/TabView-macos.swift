import SwiftUI
import ComposableArchitecture

struct TabView: View {
    let store: Store<TabState, TabAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            EntriesListView(store: self.store.scope(
                state: { $0.entriesState },
                action: TabAction.entryList))
        }
    }

    var list: some View {
        List {
            NavigationLink(destination: Text("1")
                            .frame(minWidth: 120, maxWidth: .infinity)) {
                Text("1")
            }
        }
        .frame(minWidth: 120, maxWidth: .infinity)
        .listStyle(SidebarListStyle())
    }

    var master: some View {
        List {
            Text("1")
            Text("2")
            Text("3")
        }
    }
}
