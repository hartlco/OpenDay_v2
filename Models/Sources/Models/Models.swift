import Foundation

public struct EntriesSection: Codable, Identifiable, Equatable {
    public init(title: String,
                entries: [Entry]) {
        self.title = title
        self.entries = entries
    }

    //swiftlint:disable identifier_name
    public var id: String {
        return title
    }

    public let title: String
    public let entries: [Entry]
}

public struct Entry: Codable, Identifiable, Equatable, Hashable {
    //swiftlint:disable identifier_name
    public let id: String?
    public let title: String
    public let date: Date
    public let images: [ImageResource]
    public let location: Location?
    public let weather: Weather?
    public let tags: [String]?

    let body: String

    public init(id: String? = nil,
                title: String,
                bodyText: String,
                date: Date,
                images: [ImageResource] = [],
                location: Location? = nil,
                weather: Weather? = nil,
                tags: [String]? = nil) {
        self.id = id
        self.title = title

        let base64Data = bodyText.data(using: .utf8)
        let base64String = base64Data?.base64EncodedString()

        self.body = base64String ?? ""

        self.date = date
        self.images = images
        self.location = location
        self.weather = weather
        self.tags = tags
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(id)
        hasher.combine(body)
    }

    public var bodyText: String {
        guard let data = Data(base64Encoded: body) else {
            return ""
        }

        return String(data: data, encoding: .utf8) ?? ""
    }
}

public enum ImageResource: Codable, Identifiable, Equatable {
    case remote(url: URL)
    case local(data: Data, creationDate: Date?)

    enum CodingError: Error {
        case decoding(String)
    }

    enum CodingKeys: String, CodingKey {
        case type
        case value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let typeString = try? container.decode(String.self, forKey: .type),
            let valueString = try? container.decode(String.self, forKey: .value) else {
            throw CodingError.decoding("ImageResource couldn't be decoded")
        }

        switch typeString {
        case "Remote":
            guard let url = URL(string: valueString) else {
                throw CodingError.decoding("ImageResource couldn't be decoded")
            }

            self = .remote(url: url)
        case "Local":
            guard let data = Data(base64Encoded: valueString) else {
                throw CodingError.decoding("ImageResource couldn't be decoded")
            }

            self = .local(data: data, creationDate: nil)
        default:
            throw CodingError.decoding("ImageResource couldn't be decoded")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .local(let data, _):
            try? container.encode("Local", forKey: .type)
            try? container.encode(data.base64EncodedString(), forKey: .value)
        case .remote(let url):
            try? container.encode("Remote", forKey: .type)
            try? container.encode(url.absoluteString, forKey: .value)
        }
    }

    public var id: Int {
        switch self {
        case .local(let data, _):
            return data.hashValue
        case .remote(let url):
            return url.hashValue
        }
    }
}

public struct Location: Codable, Identifiable, Equatable {
    public struct Coordinates: Codable, Equatable {
        public let longitude: Double
        public let latitude: Double

        public init(longitude: Double, latitude: Double) {
            self.longitude = longitude
            self.latitude = latitude
        }
    }

    //swiftlint:disable identifier_name
    public var id: String {
        return "\(coordinates.longitude)-\(coordinates.latitude)"
    }

    public init(coordinates: Location.Coordinates,
                isoCountryCode: String,
                city: String?,
                name: String?) {
        self.coordinates = coordinates
        self.isoCountryCode = isoCountryCode
        self.city = city
        self.name = name
    }

    public let coordinates: Coordinates
    public let isoCountryCode: String
    public let city: String?
    public let name: String?

    public func localizedString(from locale: Locale = .current) -> String {
        let values = [
            name,
            city,
            locale.localizedString(forRegionCode: isoCountryCode)
        ]

        return values.compactMap {
            $0
        }.joined(separator: ", ")
    }
}
