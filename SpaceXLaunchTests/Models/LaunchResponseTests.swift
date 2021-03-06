//
//  LaunchResponseTests.swift
//  SpaceXLaunchTests
//
//  Created by Poh  Yung Kien on 19/02/2021.
//

import XCTest
@testable import SpaceXLaunch

class LaunchResponseTests: XCTestCase, DecodableTestCase {
    var sut: LaunchResponse!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        try! givenSUTFromJSON()
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
    
    func testDecodableSetsDocs() {
        XCTAssertNotNil(sut.docs)
        XCTAssertEqual(sut.docs?.count ?? -1, 2)
    }
}
