import SwiftUI
import OpenDayService
import ComposableArchitecture
import LocationService
import WeatherService

@main
struct TestApp: App {
    private let baseURL = URL(string: "http://192.168.10.50:8000")!

    var body: some Scene {
        WindowGroup {
            tabView
        }
    }

    var tabView: TabView {
        let locationService = LocationService(locationManager: .init())
        let openDayService = OpenDayService(baseURL: baseURL,
                                            client: URLSession.shared)
        let queue = DispatchQueue.main.eraseToAnyScheduler()

        let entryEnviornment = EntryEnviornment(service: openDayService,
                                                mainQueue: queue,
                                                locationService: locationService,
                                                weatherService: WeatherService(key: Secrets.weatherServiceSecret))

        let entriesEnviornment = EntriesListEnviornment(service: openDayService,
                                                        mainQueue: queue,
                                                        entryEnviornment: entryEnviornment)

        let mapEnviornment = MapViewEnviornment(entryEnviornment: entryEnviornment)

        let tabEnviornment = TabEnviornment(entriesListEnviornment: entriesEnviornment,
                                            mapViewEnviornment: mapEnviornment)
        let tabView = TabView(store: Store(initialState: TabState(),
                                           reducer: tabReducer.debug(),
                                           environment: tabEnviornment))
        return tabView
    }
}
