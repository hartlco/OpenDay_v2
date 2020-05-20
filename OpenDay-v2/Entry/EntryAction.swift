import Foundation
import ComposableArchitecture
import Models

enum EntryAction {
    case updateTitle(text: String)
    case loadLocation
    case updateEntryIfNeeded
    case updated
    case currentLocationChanged(Result<Location, Error>)
}
