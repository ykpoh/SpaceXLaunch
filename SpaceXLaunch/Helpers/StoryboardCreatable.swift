//
//  StoryboardCreatable.swift
//  SpaceXLaunch
//
//  Created by Poh  Yung Kien on 20/02/2021.
//

import UIKit

protocol StoryboardCreatable: class {
    static var storyboard: UIStoryboard { get }
    static var storyboardBundle: Bundle? { get }
    static var storyboardIdentifier: String { get }
    static var storyboardName: String { get }
    
    static func instanceFromStoryboard() -> Self
}
