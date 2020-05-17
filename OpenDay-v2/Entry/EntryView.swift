import Foundation
import ComposableArchitecture
import SwiftUI

struct EntryView: View {
    let store: Store<EntryState, EntryAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
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
            }
        }
    }
}

