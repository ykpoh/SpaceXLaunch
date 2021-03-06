//
//  Rocket.swift
//  SpaceXLaunch
//
//  Created by Poh  Yung Kien on 20/02/2021.
//

import Foundation

struct Rocket: Codable, Equatable {
    let name: String?
    let description: String?
    let flickr_images: [URL]?
    let wikipedia: URL?
    
    init(name: String?, description: String?, flickr_images: [URL]?, wikipedia: URL?) {
        self.name = name
        self.description = description
        self.flickr_images = flickr_images
        self.wikipedia = wikipedia
    }
}
