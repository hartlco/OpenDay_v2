import Foundation
import Models

enum LocationSearchAction {
    case searchTextChanged(String)
    case search
    case locationsChanged(Result<[Location], Error>)
    case selectLocation(Location)
}
