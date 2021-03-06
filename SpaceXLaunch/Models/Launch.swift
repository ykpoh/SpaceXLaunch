//
//  Launch.swift
//  SpaceXLaunch
//
//  Created by Poh  Yung Kien on 19/02/2021.
//

import Foundation

struct Launch: Codable, Equatable {
    let id: String?
    let name: String?
    let details: String?
    let date_utc: Date?
    let upcoming: Bool?
    let success: Bool?
    let rocket: String?
    
    init(id: String?, name: String?, details: String?, date_utc: Date?, upcoming: Bool?, success: Bool?, rocket: String?) {
        self.id = id
        self.name = name
        self.details = details
        self.date_utc = date_utc
        self.upcoming = upcoming
        self.success = success
        self.rocket = rocket
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        details = try container.decodeIfPresent(String.self, forKey: .details)
        upcoming = try container.decodeIfPresent(Bool.self, forKey: .upcoming)
        success = try container.decodeIfPresent(Bool.self, forKey: .success)
        rocket = try container.decodeIfPresent(String.self, forKey: .rocket)
        if let dateString = try container.decodeIfPresent(String.self, forKey: .date_utc) {
            date_utc = DateFormatter.iso8601Full.date(from: dateString)
        } else {
            date_utc = nil
        }
    }
}
