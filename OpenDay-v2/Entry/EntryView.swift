import Foundation
import ComposableArchitecture
import SwiftUI
import TextView

struct EntryView: View {
    let store: Store<EntryState, EntryAction>

    @State private var bodyHeight: CGFloat = 40

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                Section {
                    TextField(
                      "Title",
                      text: viewStore.binding(get: { $0.title },
                                              send: EntryAction.updateTitle(text:))
                    )
                    ExpandingTextView(placeholder: "Body",
                                      text: viewStore.binding(get: { $0.body },
                                      send: EntryAction.updateBody(text:)),
                                      minHeight: self.bodyHeight,
                                      calculatedHeight: self.$bodyHeight)
                }
                Section {
                    Button(action: {
                        viewStore.send(EntryAction.updateEntryIfNeeded)
                    }) {
                        Text("Update")
                    }
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

