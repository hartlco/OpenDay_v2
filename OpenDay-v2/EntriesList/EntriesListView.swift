import Foundation
import ComposableArchitecture
import SwiftUI
import Models

struct EntriesListView: View {
    let store: Store<EntriesListState, EntriesListAction>

    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                List {
                    ForEach(viewStore.sections) { (section: EntriesSection) in
                        Section(header: Text(section.title)) {
                            ForEach(section.entries) { (entry: Entry) in
                                NavigationLink(
                                  destination: IfLetStore(
                                    self.store.scope(
                                      state: { $0.selection?.value }, action: EntriesListAction.entry),
                                    then: EntryView.init(store:),
                                    else: Text("Test")
                                  ),
                                  tag: entry,
                                  selection: viewStore.binding(
                                    get: { $0.selection?.id },
                                    send: EntriesListAction.setNavigation(selection:)
                                  )
                                ) {
                                    Text(entry.title)
                                }
                            }
                        }
                    }
                }
                .onAppear() {
                    viewStore.send(.loadingTriggered)
                }
            }
            .navigationBarTitle("Entries")
        }
    }
}
