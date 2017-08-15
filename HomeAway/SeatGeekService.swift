//
//  SeatGeekService.swift
//  HomeAway
//
//  Created by Austin Cherry on 8/14/17.
//  Copyright © 2017 Vluxe. All rights reserved.
//

import Foundation
import SwiftHTTP
import Freddy

class SeatGeekClient {
    static let shared = SeatGeekClient() // singleton, so it is only instantiated once.
    static let SeatGeekErrorDomain = "com.homeaway.seatgeek"
    static let SeatGeekDeserializationCode = 100 // custom error codes for JSON parsing.
    static let kAPIVersion = 2
    static let favoritedKey = "favorited"
    let baseURL = "https://api.seatgeek.com/\(kAPIVersion)"
    let clientID = "ODUxMTY4NHwxNTAyNzM2MDgyLjY3"
    let clientSecret = "fb57af02b890c509b51dd630f73f8f6f12009bd78ac93ac203771422d60e5059"
    var favorited = [Int]()
    
    init() {
        // check to make sure the key exist, if it does load up our favorited event ids.
        // This is a real easy way to store non-sensitive data between launches.
        if let f = UserDefaults.standard.array(forKey: SeatGeekClient.favoritedKey) {
            favorited = f as! [Int]
        }
    }
    
    /// Return results from the SeatGeek Event API. 
    /// - Parameter query: The query string to search the events.
    /// - Parameter completion: This is closure that returns events and error as optionals.
    /// Since this is making an HTTP round trip, so it is async. That is the reason we have the closure/callback when
    /// we get a response from the API. We then parse it and send the data back to the caller.
    func getEvents(query: String, lat completion: @escaping (([Event]?, Error?) -> Void)) {
        do {
            let opt = try HTTP.GET("\(baseURL)/events", parameters: ["q": query, "client_id": clientID, "client_secret": clientSecret])
            opt.start { response in
                if let error = response.error {
                    completion(nil, error)
                    return
                }
                do {
                    let json = try JSON(data: response.data)
                    var events = [Event]()
                    for json in try json.getArray(at: "events") {
                        let event = try Event(json: json)
                        events.append(event)
                    }
                    completion(events, nil)
                } catch {
                    let error = NSError(domain: SeatGeekClient.SeatGeekErrorDomain, code: SeatGeekClient.SeatGeekDeserializationCode, userInfo: nil)
                    completion(nil, error as Error)
                }
            }
        } catch let error {
            completion(nil, error)
        }
    }
    
    /// updateFavorite is a simple function for storing favorited events on disk.
    func updateFavorite(eventId: Int, isFavorited: Bool) {
        if isFavorited {
            favorited.append(eventId)
        } else {
            favorited = favorited.filter { $0 != eventId }
        }
        UserDefaults.standard.set(favorited, forKey: SeatGeekClient.favoritedKey)
        UserDefaults.standard.synchronize()
    }
    
    /// checks if the event has been favorited.
    func checkFavorited(eventId: Int) -> Bool {
        return favorited.contains(eventId)
    }
    
}
