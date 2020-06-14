import Foundation
import ComposableArchitecture
import Models

let entryImagesReducer = Reducer<EntryImagesState, EntryImagesAction, EntryImagesEnviornment> { state, action, _ in
    switch action {
    case .removeImage(let imageResource):
        state.images.removeAll {
            $0 == imageResource
        }

        return .none
    case .presentImagePicker(let showing):
        state.isShowingImagePicker = showing

        return .none
    case .imagePicked(let image, let location, let date):
        guard let jpgData = image.jpegData(compressionQuality: 0.8) else {
            return .none
        }

        state.dateOfLastAddedImage = date
        state.locationOfLastAddedImage = location

        if location != nil, date != nil {
            state.isShowingImageDatePopup = true
        }

        let imageResource = ImageResource.local(data: jpgData,
                                                creationDate: date)

        state.images.append(imageResource)

        return .none
    case .presentImageDatePopup(let showing):
        state.isShowingImageDatePopup = showing

        return .none
    case .useImageLocationDate:
        return .none
    }
}
