import Foundation
import ComposableArchitecture
import SwiftUI
import Models
import KingfisherSwiftUI

struct EntriesListView: View {
    let store: Store<EntriesListState, EntriesListAction>

    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                List {
                    ForEach(viewStore.sections) { section in
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
                                    EntryListRow(entry: entry)
                                        .contextMenu {
                                            Button(
                                                action: {
                                                    viewStore.send(.delete(entry))
                                            }, label: {
                                                Text("Delete")
                                            })
                                    }
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    viewStore.send(.loadingTriggered)
                }
                .navigationBarTitle("Entries")
                .navigationBarItems(trailing:
                    NavigationLink(
                        destination: IfLetStore(
                        self.store.scope(
                            state: { $0.newEntryState },
                            action: EntriesListAction.entry),
                        then: EntryView.init(store:),
                        else: Text("Test")
                    ), isActive: viewStore.binding(
                        get: { $0.showsAddEntry },
                        send: EntriesListAction.showAddEntry
                    )) {
                        Text("Add")
                    })
            }
        }
    }
}

struct EntryListRow: View {
    let entry: Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.title)
                .font(.system(.headline, design: .rounded))
            Text(entry.bodyText)
                .font(.caption)
            HStack {
                ForEach(entry.images) { image in
                    KFImage
                        .image(for: image)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .cornerRadius(4.0)
                }
            }
        }
    }
}
