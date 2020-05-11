import Foundation
import ComposableArchitecture
import OpenDayService
import Models
import Combine

extension OpenDayService {
    var entries: Effect<[EntriesSection], Error> {
        return Effect<[EntriesSection], Error>(perform(endpoint: .entries))
    }

    var deleteEntry: (Entry) -> Effect<String, Error> {
        return { entry in
            let future: Future<String, Error> = self.perform(endpoint: .deleteEntry(entry))
            return Effect(future)
        }
    }
}
