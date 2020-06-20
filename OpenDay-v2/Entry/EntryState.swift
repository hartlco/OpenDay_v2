import Foundation
import Models
import CoreLocation
import ComposableArchitecture

struct EntryState: Equatable {
    var entry: Entry?

    var title: String
    var body: String
    var date: Date
    var currentLocation: Location?
    var weather: Weather?

    var showsLocationSearchView = false

    var entryTagState: EntryTagState
    var entryImagesState: EntryImagesState
    var locationSearchViewState: LocationSearchViewState

    static func from(entry: Entry) -> EntryState {
        let tagState = EntryTagState(tags: entry.tags ?? [])
        let imagesState = EntryImagesState(images: entry.images)

        let entryState = EntryState(entry: entry,
                                    title: entry.title,
                                    body: entry.bodyText,
                                    date: entry.date,
                                    currentLocation: entry.location,
                                    weather: entry.weather,
                                    entryTagState: tagState,
                                    entryImagesState: imagesState, locationSearchViewState: LocationSearchViewState())

        return entryState
    }

    static func empty() -> EntryState {
        let tagState = EntryTagState(tags: [])
        let imageState = EntryImagesState(images: [])

        let entryState = EntryState(entry: nil,
                                    title: "",
                                    body: "",
                                    date: Date(),
                                    currentLocation: nil,
                                    weather: nil,
                                    entryTagState: tagState,
                                    entryImagesState: imageState, locationSearchViewState: LocationSearchViewState())
        return entryState
    }
}
