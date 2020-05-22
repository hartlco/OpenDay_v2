import Foundation
import ComposableArchitecture
import OpenDayService
import Models
import Combine

extension OpenDayService {
    var entries: Effect<[EntriesSection], Error> {
        return Effect<[EntriesSection], Error>(perform(endpoint: .entries))
    }

    func update(entry: Entry,
                title: String?,
                body: String?,
                date: Date?,
                location: Location?,
                weather: Weather?,
                images: [ImageResource]?) -> Effect<String, Error> {
        let newEntry = Entry(id: entry.id,
                             title: title ?? entry.title,
                             bodyText: body ?? entry.bodyText,
                             date: date ?? entry.date,
                             images: images ?? entry.images,
                             location: location ?? entry.location,
                             weather: weather ?? entry.weather,
                             tags: entry.tags)
        let future: Future<String, Error> = self.perform(endpoint: .updateEntry(newEntry))
        return Effect(future)
    }

    var deleteEntry: (Entry) -> Effect<String, Error> {
        return { entry in
            let future: Future<String, Error> = self.perform(endpoint: .deleteEntry(entry))
            return Effect(future)
        }
    }
}
