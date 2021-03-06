//
//  LaunchTests.swift
//  SpaceXLaunchTests
//
//  Created by Poh  Yung Kien on 19/02/2021.
//

import XCTest
@testable import SpaceXLaunch

class LaunchTests: XCTestCase {
    var sut: Launch!
    
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
    
    func testDecodableSetsId() {
        XCTAssertEqual(sut.id, "5eb87cd9ffd86e000604b32a")
    }
    
    func testDecodableSetsName() {
        XCTAssertEqual(sut.name, "FalconSat")
    }
    
    func testDecodableSetsDetails() {
        XCTAssertEqual(sut.details, "Engine failure at 33 seconds and loss of vehicle")
    }
    
    func testDecodableSetsDateUTC() {
        XCTAssertEqual(sut.date_utc, DateFormatter.iso8601Full.date(from: "2006-03-24T22:30:00.000Z"))
    }
    
    func testDecodableSetsUpcoming() {
        XCTAssertEqual(sut.upcoming, false)
    }
    
    func testDecodableSetsSuccess() {
        XCTAssertEqual(sut.success, false)
    }
    
    func testDecodableSetsRocket() {
        XCTAssertEqual(sut.rocket, "5e9d0d95eda69955f709d1eb")
    }
    
    private func givenSUTFromJSON() throws {
        let decoder = JSONDecoder()
        let data = try Data.fromJSON(fileName: "\(LaunchResponse.self)")
        let launchResponse = try decoder.decode(LaunchResponse.self, from: data)
        sut = launchResponse.docs?.first
    }
}
