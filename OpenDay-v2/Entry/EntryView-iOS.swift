import Foundation
import ComposableArchitecture
import SwiftUI
import KingfisherSwiftUI

struct EntryView: View {
    let store: Store<EntryState, EntryAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                Section(header: Text("Content")) {
                    TextField(
                      "Title",
                      text: viewStore.binding(
                        get: { $0.title },
                        send: EntryAction.updateTitle(text:)
                        )
                    )
                    ZStack {
                        TextEditor(text: viewStore.binding(
                            get: { $0.body },
                            send: EntryAction.updateBody(text:)
                        ))
                        Text(viewStore.body).opacity(0).padding(.all, 8)
                    }
                }
                Section(header: Text("Date")) {
                    DatePicker(
                        selection: viewStore.binding(
                        get: { $0.date },
                        send: EntryAction.updateDate(date:)
                        ),
                        in: Date(timeIntervalSince1970: 0)...,
                        displayedComponents: .date
                    ) {
                            Text("Date")
                    }
                    DatePicker(
                        selection: viewStore.binding(
                            get: { $0.date },
                            send: EntryAction.updateDate(date:)
                        ),
                        in: Date(timeIntervalSince1970: 0)...,
                        displayedComponents: .hourAndMinute
                    ) {
                            Text("Time")
                    }
                }
                EntryImagesView(store: self.store.scope(
                    state: { $0.entryImagesState },
                    action: EntryAction.imageAction)
                )
                Section {
                    viewStore.currentLocation.map {
                        Text($0.localizedString())
                    }
                    Button(
                        action: {
                        viewStore.send(.loadLocation)
                    }, label: {
                        Text("Load current location")
                    })
                    LocationSearchView(
                        store: self.store.scope(
                            state: { $0.locationSearchViewState },
                            action: EntryAction.locationSearchAction)
                    )
                }
                Section {
                    viewStore.weather.map {
                        Text("\($0.fahrenheit)")
                    }
                }
                EntryTagView(
                    store: self.store.scope(
                        state: { $0.entryTagState },
                        action: EntryAction.tagAction)
                )
            }
            .listStyle(GroupedListStyle())
            .navigationBarItems(trailing:
                Button(
                action: {
                    viewStore.send(.updateEntryIfNeeded)
                }, label: {
                    Text("Save")
                }))
            .navigationBarTitle("Entry")
        }
    }
}
