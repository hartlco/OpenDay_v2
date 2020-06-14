import ComposableArchitecture

enum EntryTagAction {
    case updateEnteringTag(String)
    case addTag
    case removeTag(String)
}
