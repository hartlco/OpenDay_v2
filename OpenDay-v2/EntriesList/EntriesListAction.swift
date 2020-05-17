import Foundation
import ComposableArchitecture
import Models

enum EntriesListAction {
    case loadingTriggered
    case entriesResponse(Result<[EntriesSection], Error>)
    case delete(Entry)
    case setNavigation(selection: Entry?)
    case entry(EntryAction)
}
