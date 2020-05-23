import Foundation

enum TabAction {
    case setSelection(TabState.Tab)
    case entryList(EntriesListAction)
}
