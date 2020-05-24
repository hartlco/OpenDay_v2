import Foundation
import Combine

public final class WeatherService {
    public enum WeatherIcon: String, Codable {
        case clearDay = "clear-day"
        case clearNight = "clear-night"
        case rain
        case snow
        case sleet
        case wind
        case fog
        case cloudy
        case partlyCloudyDay = "partly-cloudy-day"
        case partlyCloudyNight = "partly-cloudy-night"
    }

    public struct WeatherData: Codable {
        public let icon: WeatherIcon
        private let temperature: Double

        public var temperatureFahrenheit: Double {
            return temperature
        }

        public var temperatureCelcius: Double {
              (temperature - 32) * 5 / 9
        }
    }

    public struct WeatherDataResponse: Codable {
        let currently: WeatherData
    }

    public enum WeatherServiceError: Error {
        case unableToParse
        case connectionError
    }

    private let urlSession: URLSession
    private let key: String

    private let forseBaseURLString = "https://api.darksky.net/forecast"

    public init(urlSession: URLSession = .shared,
                key: String) {
        self.urlSession = urlSession
        self.key = key
    }

    public func getData(date: Date? = nil,
                        latitude: Double,
                        longitude: Double) -> Future<WeatherData, Error> {
        let date = date ?? Date()
        let timestamp = Int(date.timeIntervalSince1970)
        let urlString = "\(self.forseBaseURLString)/" +
        "\(self.key)/" +
        "\(latitude)," +
        "\(longitude)," +
        "\(timestamp)?units=us"

        return Future<WeatherData, Error> { promise in
            let url = URL(string: urlString)!

            self.urlSession.dataTask(with: url) { data, _, _ in
                guard let data = data else {
                    DispatchQueue.main.async {
                        promise(.failure(WeatherServiceError.connectionError))
                    }

                    return
                }

                guard let weatherDataResponse = try? JSONDecoder().decode(WeatherDataResponse.self, from: data) else {
                    DispatchQueue.main.async {
                        promise(.failure(WeatherServiceError.unableToParse))
                    }

                    return
                }

                DispatchQueue.main.async {
                    promise(.success(weatherDataResponse.currently))
                }
            }.resume()
        }
    }
}
