import UIKit
import SwiftUI
import OpenDayService
import ComposableArchitecture
import LocationService
import WeatherService

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private let baseURL = URL(string: "http://192.168.10.50:8000")!

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
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

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: tabView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
