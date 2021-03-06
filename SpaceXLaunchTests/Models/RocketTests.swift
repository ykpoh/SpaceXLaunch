//
//  RocketTests.swift
//  SpaceXLaunchTests
//
//  Created by Poh  Yung Kien on 20/02/2021.
//

import XCTest
@testable import SpaceXLaunch

class RocketTests: XCTestCase, DecodableTestCase {
    var sut: Rocket!
        
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        try givenSUTFromJSON()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Type Tests
    func testConformsToDecodable() {
        XCTAssertTrue((sut as Any) is Decodable) // cast silences a warning
    }
    
    func testConformsToEquatable() {
        XCTAssertEqual(sut, sut) // requires Equatable conformance
    }
    
    func testDecodableSetsName()  {
        XCTAssertEqual(sut.name, "Falcon Heavy")
    }
    
    func testDecodableSetsDescription()  {
        XCTAssertEqual(sut.description, "With the ability to lift into orbit over 54 metric tons (119,000 lb)--a mass equivalent to a 737 jetliner loaded with passengers, crew, luggage and fuel--Falcon Heavy can lift more than twice the payload of the next closest operational vehicle, the Delta IV Heavy, at one-third the cost.")
    }
    
    func testDecodableSetsWikipedia()  {
        XCTAssertEqual(sut.wikipedia, URL(string: "https://en.wikipedia.org/wiki/Falcon_Heavy"))
    }
    
    func testDecodableSetsFlickr_images() {
        XCTAssertEqual(sut.flickr_images, [
            URL(string: "https://farm5.staticflickr.com/4599/38583829295_581f34dd84_b.jpg")!,
            URL(string: "https://farm5.staticflickr.com/4645/38583830575_3f0f7215e6_b.jpg")!,
            URL(string: "https://farm5.staticflickr.com/4696/40126460511_b15bf84c85_b.jpg")!,
            URL(string: "https://farm5.staticflickr.com/4711/40126461411_aabc643fd8_b.jpg")!
        ])
    }
}
