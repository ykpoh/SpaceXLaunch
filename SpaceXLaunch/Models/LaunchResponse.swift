//
//  LaunchResponse.swift
//  SpaceXLaunch
//
//  Created by Poh  Yung Kien on 19/02/2021.
//

import Foundation

struct LaunchResponse: Codable, Equatable {
    let docs: [Launch]?
}
