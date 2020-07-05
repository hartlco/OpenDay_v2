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
                List(viewStore.sections) { section in
                    Section {
                        ForEach(section.entries) { (entry: Entry) in
                            NavigationLink(
                              destination: EntryView(store: self.store.scope(
                                state: { $0.detailState },
                                action: EntriesListAction.entry)
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
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            viewStore.send(.loadingTriggered)
                        }, label: {
                            Text("Load")
                        })
                    }
                    ToolbarItem {
                        NavigationLink(
                            destination: EntryView(store: self.store.scope(
                                state: { $0.detailState },
                                action: EntriesListAction.entry)
                        ), isActive: viewStore.binding(
                            get: { $0.showsAddEntry },
                            send: EntriesListAction.showAddEntry
                        )) {
                            Text("Add")
                        }
                    }
                }
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

