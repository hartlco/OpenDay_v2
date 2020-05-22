import Kingfisher
import Foundation
import KingfisherSwiftUI
import Models

/// Represents an image data provider for a raw data object.
struct AsyncRawImageDataProvider: ImageDataProvider {
    let data: Data

    init(data: Data) {
        self.cacheKey = String(data.hashValue)
        self.data = data
    }
    var cacheKey: String

    func data(handler: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            handler(.success(self.data))
        }
    }
}

extension KFImage {
    static func image(for resource: Models.ImageResource) -> KFImage {
        switch resource {
        case .local(let data, _):
            return KFImage(source: .provider(AsyncRawImageDataProvider(data: data)))
        case .remote(let url):
            return KFImage(url)
        }
    }
}
