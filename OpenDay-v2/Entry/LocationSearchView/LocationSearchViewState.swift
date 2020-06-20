import Foundation
import Models

struct LocationSearchViewState: Equatable {
    var searchText = ""
    var locations: [Location] = []
}
