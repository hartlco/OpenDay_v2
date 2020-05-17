import Foundation
import ComposableArchitecture
import OpenDayService
import Models
import Combine

extension OpenDayService {
    var entries: Effect<[EntriesSection], Error> {
        return Effect<[EntriesSection], Error>(perform(endpoint: .entries))
    }

    var update: (Entry, String) -> Effect<String, Error> {
        return { entry, title in
            let newEntry = Entry(id: entry.id,
                                 title: title,
                                 bodyText: entry.bodyText,
                                 date: entry.date,
                                 images: entry.images,
                                 location: entry.location,
                                 weather: entry.weather,
                                 tags: entry.tags)
            let future: Future<String, Error> = self.perform(endpoint: .updateEntry(newEntry))
            return Effect(future)
        }
    }

    var deleteEntry: (Entry) -> Effect<String, Error> {
        return { entry in
            let future: Future<String, Error> = self.perform(endpoint: .deleteEntry(entry))
            return Effect(future)
        }
    }
}
