import ComposableArchitecture
import Models

let entryReducer = Reducer<EntryState, EntryAction, EntryEnviornment>.combine(
Reducer { state, action, enviornment in
    switch action {
    case .updated:
        return .none
    case .updateTitle(let text):
        state.title = text
        return .none
    case .updateBody(let text):
        state.body = text
        return .none
    case .updateWeather(let weather):
        switch weather {
        case .success(let weather):
            let weatherIcon = WeatherIcon(rawValue: weather.icon.rawValue)
            state.weather = Weather(weatherSymbol: weatherIcon, fahrenheit: Int(weather.temperatureFahrenheit))
        case .failure:
            state.weather = nil
        }

        return .none
    case .updateEntryIfNeeded:
        return enviornment
            .service
            .createOrUpdate(entry: state.entry,
                    title: state.title,
                    body: state.body,
                    date: state.date,
                    location: state.currentLocation,
                    weather: state.weather,
                    images: state.entryImagesState.images,
                    tags: state.entryTagState.tags)
        .catchToEffect()
        .map { _ in
            return .updated
        }
    case .loadLocation:
        return enviornment.locationService
            .getLocation()
            .receive(on: enviornment.mainQueue)
            .catchToEffect()
            .map(EntryAction.currentLocationChanged)
    case .showsLocationSearchView(let value):
        state.showsLocationSearchView = value

        return .none
    case .currentLocationChanged(let result):
        switch result {
        case .success(let location):
            state.currentLocation = location
            return enviornment.weatherService.getData(date: state.date,
                                               latitude: location.coordinates.latitude,
                                               longitude: location.coordinates.longitude)
                .receive(on: enviornment.mainQueue)
                .catchToEffect()
                .map(EntryAction.updateWeather)
        case .failure:
            state.currentLocation = nil
        }

        return .none
    case .updateDate(let date):
        state.date = date

        guard let location = state.currentLocation else {
            return .none
        }

        return enviornment.weatherService.getData(date: state.date,
                                       latitude: location.coordinates.latitude,
                                       longitude: location.coordinates.longitude)
        .receive(on: enviornment.mainQueue)
        .catchToEffect()
        .map(EntryAction.updateWeather)
    case .tagAction:
        return .none
    case .imageAction(let action):
        switch action {
        case .useImageLocationDate:
            state.date = state.entryImagesState.dateOfLastAddedImage ?? state.date

            guard let location = state.entryImagesState.locationOfLastAddedImage else {
                return .none
            }

            return enviornment.locationService
                .getLocation(from: location)
                .receive(on: enviornment.mainQueue)
                .catchToEffect()
                .map(EntryAction.currentLocationChanged)
        default:
            return .none
        }
    case .locationSearchAction(let action):
        switch action {
        case .selectLocation(let location):
            state.currentLocation = location

            return .none
        default:
            return .none
        }
    }
},
entryTagReducer.pullback(state: \EntryState.entryTagState,
                         action: /EntryAction.tagAction,
                         environment: { _ in
                            EntryTagEnviornment()

}),
entryImagesReducer.pullback(state: \EntryState.entryImagesState,
                            action: /EntryAction.imageAction,
                            environment: { _ in
                                EntryImagesEnviornment()
}),
locationSearchViewReducer.pullback(state: \EntryState.locationSearchViewState,
                                   action: /EntryAction.locationSearchAction,
                                   environment: { enviornment in
                                    enviornment.locationSearchEnviornment
})
)
