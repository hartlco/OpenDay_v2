import SwiftUI
import ComposableArchitecture
import KingfisherSwiftUI
import ImagePicker

struct EntryImagesView: View {
    let store: Store<EntryImagesState, EntryImagesAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            Section {
                ForEach(viewStore.images) { image in
                    KFImage.image(for: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .contextMenu {
                            Button(action: {
                                viewStore.send(.removeImage(image))
                            }, label: {
                                Text("Delete")
                            })
                    }
                }
                Button(action: {
                    viewStore.send(.presentImagePicker(true))
                }, label: {
                    Text("Add Image")
                })
                .sheet(isPresented: viewStore.binding(
                    get: { $0.isShowingImagePicker },
                    send: EntryImagesAction.presentImagePicker
                )) {
                    ImagePicker { image, location, date in
                        viewStore.send(.imagePicked(image: image,
                                                    location: location,
                                                    date: date))
                    }
                }
                .alert(isPresented: viewStore.binding(
                    get: { $0.isShowingImageDatePopup },
                    send: EntryImagesAction.presentImageDatePopup
                )) {
                    Alert(title: Text("Use Location/Date"),
                          primaryButton: .default(Text("Yes"),
                                                  action: { viewStore.send(.useImageLocationDate) }),
                          secondaryButton: .cancel())
                }
            }
        }
    }
}
