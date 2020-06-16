import Foundation
import ComposableArchitecture
import SwiftUI
import TextView
import KingfisherSwiftUI

struct EntryView: View {
    let store: Store<EntryState, EntryAction>

    @State private var bodyHeight: CGFloat = 40

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
                    ExpandingTextView(
                        placeholder: "Body",
                        text: viewStore.binding(
                            get: { $0.body },
                            send: EntryAction.updateBody(text:)
                        ),
                        minHeight: self.bodyHeight,
                        calculatedHeight: self.$bodyHeight
                    )
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
                Section {
                    Button(action: {
                        viewStore.send(.updateEntryIfNeeded)
                    }, label: {
                        Text("Update")
                    })
                }
                EntryImagesView(store: self.store.scope(
                    state: { $0.entryImagesState },
                    action: EntryAction.imageAction)
                )
                Section {
                    viewStore.currentLocation.map {
                        Text($0.city ?? "")
                    }
                    Button(
                        action: {
                        viewStore.send(.loadLocation)
                    }, label: {
                        Text("Load current location")
                    })
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
            .navigationBarTitle("Entry")
        }
    }
}
