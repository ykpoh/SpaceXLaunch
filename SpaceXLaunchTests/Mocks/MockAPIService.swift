//
//  MockAPIService.swift
//  SpaceXLaunchTests
//
//  Created by Poh  Yung Kien on 20/02/2021.
//

@testable import SpaceXLaunch
import Alamofire

enum MockAPIServiceError: Error {
    case permissionDenied
}

class MockAPIService: APIServiceProtocol {
    enum Status {
        case success
        case error
    }
    var mockLaunchResponse: LaunchResponse?
    var mockRocket: Rocket?
    var mockErrorResponse: Error?
    var isFetchLaunchesWithQuery = false
    var isFetchRocket = false
    var status: Status = .success
    var completionHandler: ((LaunchResponse?, Error?, AFDataResponse<Any>) -> Void)?
    
    @discardableResult func fetchLaunchesWithQuery(startDate: Date = Calendar.current.date(byAdding: .year, value: -3, to: Date()) ?? Date(), endDate: Date = Date(), completion: @escaping (LaunchResponse?, Error?, AFDataResponse<Any>) -> Void) -> DataRequestProtocol {
        isFetchLaunchesWithQuery = true
        
        let mockDataResponse = generateMockDataResponse()
        
        switch status {
        case .success:
            completion(mockLaunchResponse, nil, mockDataResponse)
        case .error:
            completion(nil, mockErrorResponse, mockDataResponse)
        }
        return MockDataRequest()
    }
    
    func fetchRocket(rocketName: String, completion: @escaping (Rocket?, Error?, AFDataResponse<Any>) -> Void) -> DataRequestProtocol {
        isFetchRocket = true
        
        let mockDataResponse = generateMockDataResponse()
        
        switch status {
        case .success:
            completion(mockRocket, nil, mockDataResponse)
        case .error:
            completion(nil, mockErrorResponse, mockDataResponse)
        }
        return MockDataRequest()
    }
    
    private func generateMockDataResponse() -> AFDataResponse<Any> {
        return AFDataResponse<Any>(
            request: nil,
            response: HTTPURLResponse(url: URL(string: "test.ykpoh.com")!, statusCode: MockDataRequest.statusCode, httpVersion: "1.1", headerFields: nil),
            data: MockDataRequest.data,
            metrics: nil,
            serializationDuration: TimeInterval(),
            result: Result.success(true)
        )
    }
}
