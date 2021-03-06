//
//  Data+Extensions.swift
//  SpaceXLaunchUITests
//
//  Created by Poh  Yung Kien on 19/02/2021.
//

import Foundation
import XCTest

extension Data {
    public static func fromJSON(fileName: String) throws -> Data {
        let bundle = Bundle(for: TestBundleClass.self)
        let url = try XCTUnwrap(bundle.url(forResource: fileName, withExtension: "json"))
        return try Data(contentsOf: url)
    }
}

private class TestBundleClass { }
