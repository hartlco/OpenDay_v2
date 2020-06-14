import ComposableArchitecture

struct EntryTagState: Equatable {
    var tags: [String]
    var enteringTag = ""
}

extension String: Identifiable {
    //swiftlint:disable identifier_name
    public var id: String {
        return self
    }
}
