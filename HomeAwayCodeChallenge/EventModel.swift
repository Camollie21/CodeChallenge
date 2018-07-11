//
//  EventModel.swift
//  HomeAwayCodeChallenge
//
//  Created by Cameron Ollivierre on 6/25/18.
//  Copyright © 2018 Cameron Ollivierre. All rights reserved.
//

import Foundation

struct Response: Decodable{
    let events: [Event]
}

struct Event: Decodable {
    let title: String
    let dateAndTime: String
    let id: Int
    let venue: Venue
    let performers: [Performer]
    
    enum CodingKeys : String, CodingKey {
        case title = "short_title"
        case dateAndTime = "datetime_utc"
        case id
        case venue
        case performers
    }
}

struct Venue: Decodable{
    let name: String
    let location: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case location = "display_location"
    }
}

struct Performer: Decodable{
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image"
    }
}
