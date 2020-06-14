import SwiftUI
import ComposableArchitecture

struct EntryTagView: View {
    let store: Store<EntryTagState, EntryTagAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            Section(header: Text("Tags")) {
                ForEach(viewStore.tags) { tag in
                    Text(tag)
                        .contextMenu {
                            Button(action: {
                                viewStore.send(.removeTag(tag))
                            }, label: {
                                Text("Delete")
                            })
                    }
                }
                TextField(
                  "New Tag",
                  text: viewStore.binding(get: { $0.enteringTag },
                                          send: EntryTagAction.updateEnteringTag),
                  onCommit: { viewStore.send(.addTag) }
                )
            }
        }
    }
}
