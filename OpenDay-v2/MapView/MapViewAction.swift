import Foundation
import Models

enum MapViewAction {
    case locationsChanged
    case didSelectLocation(Location)
    case showsDetail(Bool)
    case entryAction(EntryAction)
}
