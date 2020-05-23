import Foundation
import ComposableArchitecture
import SwiftUI
import TextView
import KingfisherSwiftUI
import ImagePicker

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
                Section(header: Text("Date")) {
                    DatePicker(selection: viewStore.binding(get: { $0.date },
                                                            send: EntryAction.updateDate(date:)),
                               in: Date(timeIntervalSince1970: 0)...,
                               displayedComponents: .date) {
                                Text("Date")
                    }
                    DatePicker(selection: viewStore.binding(get: { $0.date },
                                                            send: EntryAction.updateDate(date:)),
                               in: Date(timeIntervalSince1970: 0)...,
                               displayedComponents: .hourAndMinute) {
                                Text("Time")
                    }
                }
                Section {
                    Button(action: {
                        viewStore.send(.updateEntryIfNeeded)
                    }) {
                        Text("Update")
                    }
                }
                Section {
                    ForEach(viewStore.images) { image in
                        KFImage.image(for: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .contextMenu {
                                Button(action: {
                                    viewStore.send(EntryAction.removeImage(image))
                                }, label: {
                                    Text("Delete")
                                })
                        }
                    }
                    Button(action: {
                        viewStore.send(EntryAction.presentImagePicker(true))
                    }) {
                        Text("Add Image")
                    }
                    .sheet(isPresented: viewStore.binding(
                        get: { $0.isShowingImagePicker },
                        send: EntryAction.presentImagePicker
                    )) {
                        ImagePicker { image, location, date in
                            viewStore.send(EntryAction.imagePicked(image: image,
                                                                   location: location,
                                                                   date: date))
                        }
                    }
                    .alert(isPresented: viewStore.binding(
                        get: { $0.isShowingImageDatePopup },
                        send: EntryAction.presentImageDatePopup
                    )) {
                        Alert(title: Text("Use Location/Date"),
                              primaryButton: .default(Text("Yes"),
                                                      action: { viewStore.send(.useImageLocationDate) }),
                              secondaryButton: .cancel())
                    }
                }
                Section {
                    viewStore.currentLocation.map {
                        Text($0.city ?? "")
                    }
                    Button(action: {
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
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Entry")
        }
    }
}

