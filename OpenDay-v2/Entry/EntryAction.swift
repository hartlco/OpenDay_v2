import Foundation
import ComposableArchitecture

enum EntryAction: Equatable {
    case updateTitle(text: String)
    case updateEntryIfNeeded
    case updated
}
