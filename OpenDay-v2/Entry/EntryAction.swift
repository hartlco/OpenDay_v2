import Foundation
import ComposableArchitecture
import Models

enum EntryAction {
    case updateTitle(text: String)
    case updateBody(text: String)
    case updateDate(date: Date)
    case loadLocation
    case updateEntryIfNeeded
    case updated
    case currentLocationChanged(Result<Location, Error>)
}
