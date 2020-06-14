import ComposableArchitecture

let entryTagReducer = Reducer<EntryTagState, EntryTagAction, EntryTagEnviornment> { state, action, _ in
    switch action {
    case .updateEnteringTag(let tag):
        state.enteringTag = tag
        return .none
    case .addTag:
        let formattedTag = state.enteringTag.replacingOccurrences(of: " ",
                                                                  with: "-")
        state.tags.append(formattedTag)
        state.enteringTag = ""
        return .none
    case .removeTag(let tag):
        state.tags.removeAll {
            $0 == tag
        }
        return .none
    }
}
