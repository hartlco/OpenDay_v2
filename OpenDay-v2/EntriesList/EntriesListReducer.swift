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
                    let entryState = EntryState(entry: entry,
                                                title: newEntry.title,
                                                body: entry?.bodyText ?? "",
                                                date: entry?.date ?? Date(),
                                                currentLocation: entry?.location,
                                                weather: entry?.weather,
                                                images: entry?.images ?? [])
                    state.selection = Identified(entryState, id: newEntry)
                } else {
                    state.selection = nil
                }

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
    )
)
