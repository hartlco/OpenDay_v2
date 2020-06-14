import Foundation

enum TabAction {
    case setSelection(TabState.Tab)
    case entryList(EntriesListAction)
    case mapViewAction(MapViewAction)
}
