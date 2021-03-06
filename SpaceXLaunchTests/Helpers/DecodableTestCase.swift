//
//  DecodableTestCase.swift
//  SpaceXLaunchUITests
//
//  Created by Poh  Yung Kien on 19/02/2021.
//

import Foundation
import XCTest

protocol DecodableTestCase: class {
    associatedtype T: Decodable
    var sut: T! { get set }
}
extension DecodableTestCase {
    func givenSUTFromJSON(fileName: String = "\(T.self)") throws {
        let decoder = JSONDecoder()
        let data = try Data.fromJSON(fileName: fileName)
        sut = try decoder.decode(T.self, from: data)
    }
}
