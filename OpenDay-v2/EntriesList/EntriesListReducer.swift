import Foundation
import ComposableArchitecture
import WeatherService

let entriesListReducer = Reducer<EntriesListState,
    EntriesListAction,
EntriesListEnviornment>.combine(
    Reducer { state, action, enviornment in
            switch action {
            case .loadingTriggered:
                return enviornment.service
                    .entries
                    .receive(on: enviornment.mainQueue)
                    .catchToEffect()
                    .map(EntriesListAction.entriesResponse)
            case let .entriesResponse(.success(sections)):
                state.sections = sections
                return .none
            case let .entriesResponse(.failure(sections)):
                state.sections = []
                return .none
            case .delete(let entry):
                return enviornment.service
                .deleteEntry(entry)
                .catchToEffect()
                .map { _ in
                    return EntriesListAction.loadingTriggered
                }
            case .setNavigation(let entry):
                if let newEntry = entry {
                    let tagState = EntryTagState(tags: entry?.tags ?? [])
                    let imagesState = EntryImagesState(images: entry?.images ?? [])

                    let entryState = EntryState(entry: entry,
                                                title: newEntry.title,
                                                body: entry?.bodyText ?? "",
                                                date: entry?.date ?? Date(),
                                                currentLocation: entry?.location,
                                                weather: entry?.weather,
                                                entryTagState: tagState,
                                                entryImagesState: imagesState)
                    state.selection = Identified(entryState, id: newEntry)
                } else {
                    state.selection = nil
                }

                return .none
            case .showAddEntry(let value):
                let tagState = EntryTagState(tags: [])
                let imageState = EntryImagesState(images: [])

                let entryState = EntryState(entry: nil,
                                            title: "",
                                            body: "",
                                            date: Date(),
                                            currentLocation: nil,
                                            weather: nil,
                                            entryTagState: tagState,
                                            entryImagesState: imageState)

                state.newEntryState = entryState
                state.showsAddEntry = value

                return .none
            case .entry:
                return .none
        }
    },
    entryReducer
        .pullback(state: \Identified.value, action: .self, environment: { $0 })
        .optional
        .pullback(
            state: \EntriesListState.selection,
            action: /EntriesListAction.entry,
            environment: { enviornment in
                EntryEnviornment(service: enviornment.service,
                                 mainQueue: enviornment.mainQueue,
                                 locationService: enviornment.locationServcie,
                                 weatherService: WeatherService(key: Secrets.weatherServiceSecret))
        }
    ),
    entryReducer.optional.pullback(state: \EntriesListState.newEntryState,
                          action: /EntriesListAction.entry,
                          environment: { enviornment in
                            EntryEnviornment(service: enviornment.service,
                            mainQueue: enviornment.mainQueue,
                            locationService: enviornment.locationServcie,
                            weatherService: WeatherService(key: Secrets.weatherServiceSecret))
    })
)
