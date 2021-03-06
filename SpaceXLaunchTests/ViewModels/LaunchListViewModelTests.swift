//
//  LaunchListViewModelTests.swift
//  SpaceXLaunchTests
//
//  Created by Poh  Yung Kien on 20/02/2021.
//

import XCTest
@testable import SpaceXLaunch
import Alamofire
import RxSwift

class LaunchListViewModelTests: XCTestCase {
    var sut: LaunchListViewModel!
    var mockAPIService: MockAPIService!
    var mockViewController: MockLaunchListViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        mockAPIService = MockAPIService()
        sut = LaunchListViewModel(apiService: mockAPIService)
        givenMockViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockAPIService = nil
        mockViewController = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func testLaunchViewModels_whenInit() {
        XCTAssertTrue(sut.launchViewModels.value.isEmpty)
    }
    
    func testNotifyError_whenInit() {
        XCTAssertNil(sut.notifyError.value)
    }
    
    func testLaunchViewModelsCallback_whenUpdated() {
        // given
        let exp = expectation(for: NSPredicate(block: { (mockViewController, _) -> Bool in
            return (mockViewController as! MockLaunchListViewController).launchViewModelsCallback
        }), evaluatedWith: mockViewController, handler: nil)
        
        // when
        whenLaunchViewModels()
        
        // then
        wait(for: [exp], timeout: 2.0)
    }
    
    func testNotifyErrorCallback_whenUpdated() {
        // given
        let exp = expectation(for: NSPredicate(block: { (mockViewController, _) -> Bool in
            return (mockViewController as! MockLaunchListViewController).notifyErrorCallback
        }), evaluatedWith: mockViewController, handler: nil)
        
        // when
        sut.notifyError.accept(MockAPIServiceError.permissionDenied)
        
        // then
        wait(for: [exp], timeout: 2.0)
    }
    
    func testFetchLaunchesWithQuerySuccess() throws {
        let launchResponse = try givenSUTFromJSON()
        let expectedLaunchTVCViewModels = sut.convertLaunchesToLaunchListTableViewCellViewModels(launches: launchResponse.docs ?? [])
        
        mockAPIService.status = .success
        mockAPIService.mockLaunchResponse = launchResponse
        mockAPIService.mockErrorResponse = nil
        
        sut.fetchLaunchesWithQuery()
        
        XCTAssertTrue(mockAPIService.isFetchLaunchesWithQuery)
        XCTAssertEqual(sut.launchViewModels.value, expectedLaunchTVCViewModels)
    }
    
    func testFetchLaunchesWithQueryError() throws {
        let expectedError = MockAPIServiceError.permissionDenied
        mockAPIService.status = .error
        mockAPIService.mockLaunchResponse = nil
        mockAPIService.mockErrorResponse = expectedError
        
        sut.fetchLaunchesWithQuery()
        
        XCTAssertTrue(mockAPIService.isFetchLaunchesWithQuery)
        XCTAssertTrue(sut.launchViewModels.value.isEmpty)
        XCTAssertEqual(sut.notifyError.value?.localizedDescription, expectedError.localizedDescription)
    }
    
    private func givenMockViewController() {
        mockViewController = MockLaunchListViewController()
        mockViewController.viewModel = sut
        mockViewController.loadViewIfNeeded()
    }
    
    private func whenLaunchViewModels(count: Int = 3) {
        guard count > 0 else {
            sut.launchViewModels.accept([])
            return
        }
        sut.launchViewModels.accept(givenLaunches(count: count).map { LaunchListTableViewCellViewModel(launch: $0) })
    }
    
    private func givenSUTFromJSON() throws -> LaunchResponse {
        let decoder = JSONDecoder()
        let data = try Data.fromJSON(fileName: "\(LaunchResponse.self)")
        let launchResponse = try decoder.decode(LaunchResponse.self, from: data)
        return launchResponse
    }
}

class MockLaunchListViewController: UIViewController {
    var viewModel: LaunchListViewModelType = LaunchListViewModel()
    var disposeBag: DisposeBag!
    var launchViewModelsCallback = false
    var notifyErrorCallback = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupListeners()
    }
    
    func setupListeners() {
        disposeBag = DisposeBag()
        
        viewModel.launchViewModels
            .asDriver()
            .drive(onNext: { [weak self] value in
                guard let strongSelf = self else { return }
                strongSelf.launchViewModelsCallback = true
            })
            .disposed(by: disposeBag)
        
        viewModel.notifyError
            .asDriver()
            .drive(onNext: { [weak self] value in
                guard let strongSelf = self else { return }
                strongSelf.notifyErrorCallback = true
            })
            .disposed(by: disposeBag)
    }
}
