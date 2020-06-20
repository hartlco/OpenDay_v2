import Foundation
import ComposableArchitecture

let mapViewReducer = Reducer<MapViewState, MapViewAction, MapViewEnviornment> { state, action, _ in
    switch action {
    case .didSelectLocation(let location):
        guard let entry = state.entries.first(where: {
            location == $0.location
        }) else {
            return .none
        }

        let tagState = EntryTagState(tags: entry.tags ?? [])
        let imagesState = EntryImagesState(images: entry.images)
        let locationSearchViewState = LocationSearchViewState()

        let entryState = EntryState(entry: entry,
                               title: entry.title,
                               body: entry.bodyText,
                               date: entry.date,
                               currentLocation: entry.location,
                               weather: entry.weather,
                               entryTagState: tagState,
                               entryImagesState: imagesState,
                               locationSearchViewState: locationSearchViewState)
        state.detailEntryState = entryState
        state.showsDetail = true
        return .none
    case .showsDetail(let value):
        state.showsDetail = false
        if !value {
            state.detailEntryState = nil
        }

        return .none
    default:
        return .none
    }
}
