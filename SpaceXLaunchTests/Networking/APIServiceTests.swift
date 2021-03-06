//
//  APIServiceTests.swift
//  SpaceXLaunchTests
//
//  Created by Poh  Yung Kien on 20/02/2021.
//

import XCTest
@testable import SpaceXLaunch
import Alamofire

class APIServiceTests: XCTestCase {
    var mockSessionManager: MockSessionManager!
    var mockDataRequest: MockDataRequest!
    var mockBaseUrlString: String!
    var sut: APIService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        mockSessionManager = MockSessionManager()
        mockDataRequest = MockDataRequest()
        mockBaseUrlString = "https://example.com/api/v1/"
        sut = APIService(baseUrlString: mockBaseUrlString, sessionManager: mockSessionManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockSessionManager = nil
        mockDataRequest = nil
        mockBaseUrlString = nil
        sut = nil
        try super.setUpWithError()
    }
    
    func testBaseUrlString_whenInit() {
        XCTAssertEqual(sut.baseUrlString, mockBaseUrlString)
    }
    
    func testFetchLaunchesWithQuery_whenCallsCompletionWithLaunchResponse() throws {
        let exp = expectation(description: "Completion wasn't called")
        
        // given
        MockDataRequest.statusCode = 200
        let data = try Data.fromJSON(fileName: "LaunchResponse")
        MockDataRequest.data = data
        
        let decoder = JSONDecoder()
        let expectedLaunchResponse = try decoder.decode(LaunchResponse.self, from: data)
        
        // when
        sut.fetchLaunchesWithQuery { launchResponse, error, _ in
            XCTAssertEqual(launchResponse, expectedLaunchResponse)
            XCTAssertNil(error)
            exp.fulfill()
        }
        
        // then
        wait(for: [exp], timeout: 2.0)
    }
    
    func testFetchLaunchesWithQuery_whenCallsCompletionWithError() throws {
        let exp = expectation(description: "Completion wasn't called")
        // given
        let expectedErrorCode = 400
        MockDataRequest.statusCode = expectedErrorCode
        MockDataRequest.data = Data()
        
        var expectedError: NSError!
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(LaunchResponse.self, from: Data())
        } catch {
            expectedError = error as NSError
        }
        
        // when
        sut.fetchLaunchesWithQuery { launchResponse, error, dataResponse in
            XCTAssertNil(launchResponse)
            XCTAssertEqual(dataResponse.response?.statusCode, expectedErrorCode)
            let actualError = try! XCTUnwrap(error as NSError?)
            XCTAssertEqual(actualError.domain, expectedError.domain)
            exp.fulfill()
        }
        
        // then
        wait(for: [exp], timeout: 2.0)
    }
    
    func testFetchRocket_whenCallsCompletionWithRocket() throws {
        let exp = expectation(description: "Completion wasn't called")
        
        // given
        MockDataRequest.statusCode = 200
        let data = try Data.fromJSON(fileName: "Rocket")
        MockDataRequest.data = data
        
        let decoder = JSONDecoder()
        let expectedRocket = try decoder.decode(Rocket.self, from: data)
        
        // when
        sut.fetchRocket(rocketName: "exampleName") { (rocket, error, _) in
            XCTAssertEqual(rocket, expectedRocket)
            XCTAssertNil(error)
            exp.fulfill()
        }
        
        // then
        wait(for: [exp], timeout: 2.0)
    }
    
    func testFetchRocket_whenCallsCompletionWithError() throws {
        let exp = expectation(description: "Completion wasn't called")
        // given
        let expectedErrorCode = 400
        MockDataRequest.statusCode = expectedErrorCode
        MockDataRequest.data = Data()
        
        var expectedError: NSError!
        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(Rocket.self, from: Data())
        } catch {
            expectedError = error as NSError
        }
        
        // when
        sut.fetchRocket(rocketName: "exampleName") { (rocket, error, dataResponse) in
            XCTAssertNil(rocket)
            XCTAssertEqual(dataResponse.response?.statusCode, expectedErrorCode)
            let actualError = try! XCTUnwrap(error as NSError?)
            XCTAssertEqual(actualError.domain, expectedError.domain)
            exp.fulfill()
        }
        
        // then
        wait(for: [exp], timeout: 2.0)
    }
}

class MockSessionManager: SessionProtocol {
    func request(_ convertible: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?) -> DataRequestProtocol {
        return MockDataRequest()
    }
}
