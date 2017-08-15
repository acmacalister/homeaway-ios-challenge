//
//  Event.swift
//  HomeAway
//
//  Created by Austin Cherry on 8/14/17.
//  Copyright © 2017 Vluxe. All rights reserved.
//

import Foundation
import Freddy

struct Performer: JSONDecodable {
    let id: Int
    let image: String?
    let name: String
    let shortName: String
    
    init(json: JSON) throws {
        id = try json.getInt(at: "id")
        image = try json.getString(at: "image", alongPath: [.missingKeyBecomesNil, .nullBecomesNil])
        name = try json.getString(at: "name")
        shortName = try json.getString(at: "short_name")
    }

}

struct Venue: JSONDecodable {
    let displayLocation: String
    
    init(json: JSON) throws {
        displayLocation = try json.getString(at: "display_location")
    }
    
}

struct Event: JSONDecodable {
    let id: Int
    let utc: String
    let url: String
    let shortTitle: String
    let title: String
    let performers: [Performer]
    let venue: Venue
    
    init(json: JSON) throws {
        id = try json.getInt(at: "id")
        utc = try json.getString(at: "datetime_utc")
        url = try json.getString(at: "url")
        shortTitle = try json.getString(at: "short_title")
        title = try json.getString(at: "title")
        performers = try json.getArray(at: "performers").map(Performer.init)
        venue = try json.decode(at: "venue")
    }
}

struct EventViewModel {
    let event: Event
    
    init(event: Event) {
        self.event = event
    }
    
    var id: Int {
        return event.id
    }
    
    var title: String {
        return event.title
    }
    
    var shortTitle: String {
        return event.shortTitle
    }
    
    var displayLocation: String {
        return event.venue.displayLocation
    }
    
    var date: String {
        return Additions.convertDate(date: event.utc)
    }
    
    var imageURL: URL? {
        guard let url = event.performers.first?.image else {return nil}
        return URL(string: url)
    }
    
    var isFavorited: Bool {
        return SeatGeekClient.shared.checkFavorited(eventId: event.id)
    }
}
