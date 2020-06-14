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
        guard let entry = state.entry else {
            return .none
        }

        return enviornment
            .service
            .update(entry: entry,
                    title: state.title,
                    body: state.body,
                    date: state.date,
                    location: state.currentLocation,
                    weather: state.weather,
                    images: state.images,
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
    case .addImage(let imageResource):
        state.images.append(imageResource)

        return .none
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

        return Effect(value: EntryAction.addImage(imageResource))
    case .presentImageDatePopup(let showing):
        state.isShowingImageDatePopup = showing

        return .none
    case .useImageLocationDate:
        state.date = state.dateOfLastAddedImage ?? state.date

        guard let location = state.locationOfLastAddedImage else {
            return .none
        }

        return enviornment.locationService
            .getLocation(from: location)
            .receive(on: enviornment.mainQueue)
            .catchToEffect()
            .map(EntryAction.currentLocationChanged)
    case .tagAction:
        return .none
    }
},
entryTagReducer.pullback(state: \EntryState.entryTagState,
                         action: /EntryAction.tagAction,
                         environment: { _ in
                            EntryTagEnviornment()

})
)
