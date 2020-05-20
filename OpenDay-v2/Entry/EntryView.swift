import Foundation
import ComposableArchitecture
import SwiftUI

struct EntryView: View {
    let store: Store<EntryState, EntryAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                TextField(
                  "Title",
                  text: viewStore.binding(get: { $0.title },
                                          send: EntryAction.updateTitle(text:))
                )
                Button(action: {
                    viewStore.send(EntryAction.updateEntryIfNeeded)
                }) {
                    Text("Update")
                }
                Section {
                    viewStore.currentLocation.map {
                        Text($0.city ?? "")
                    }
                    Button(action: {
                        viewStore.send(EntryAction.loadLocation)
                    }, label: {
                        Text("Load current location")
                    })
                }
            }
            .listStyle(GroupedListStyle())
        }
    }
}

