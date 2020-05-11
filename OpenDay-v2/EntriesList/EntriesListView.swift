import Foundation
import ComposableArchitecture
import SwiftUI
import Models

struct EntriesListView: View {
    let store: Store<EntriesListState, EntriesListAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.sections) { (section: EntriesSection) in
                    Section(header: Text(section.title)) {
                        ForEach(section.entries) { (entry: Entry) in
                            Text(entry.title)
                                .contextMenu {
                                    Button(action: {
                                        viewStore.send(.delete(entry))
                                    }) {
                                        Text("Delete")
                                    }
                            }
                        }
                    }
                }
            }
            .onAppear() {
                viewStore.send(.loadingTriggered)
            }
        }
    }
}
