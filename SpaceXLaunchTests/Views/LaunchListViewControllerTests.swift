//
//  LaunchListViewControllerTests.swift
//  SpaceXLaunchTests
//
//  Created by Poh  Yung Kien on 20/02/2021.
//

import XCTest
@testable import SpaceXLaunch
import RxCocoa

class LaunchListViewControllerTests: XCTestCase {
    var sut: LaunchListViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = LaunchListViewController.instanceFromStoryboard()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }
    
    func testTableViewNumberOfRowsInSection_whenInit_return1() {
        // given
        let expected = 1
        // when
        let actual = sut.tableView(sut.tableView, numberOfRowsInSection: 0)
        // then
        XCTAssertEqual(actual, expected)
    }
    
    func testTableViewNumberOfRowsInSection_givenHasViewModels_returnViewModelsCount() {
        // given
        let expected = 3
        givenViewModels(count: expected)
        // when
        let actual = sut.tableView(sut.tableView, numberOfRowsInSection: 0)
        // then
        XCTAssertEqual(actual, expected)
    }
    
    func testTableViewCellForRowAt_givenViewModelsSet_returnsLaunchListTableViewCell() {
        // given
        givenViewModels()
        
        // when
        let cells = whenDequeueTableViewCells()
        
        // then
        for cell in cells {
            XCTAssertTrue(cell is LaunchListTableViewCell)
        }
    }
    
    func testTableViewCellForRowAt_givenViewModelsSet_configuresTableViewCells() throws {
        // given
        givenMockViewModels()
        
        // when
        let cells = try XCTUnwrap(whenDequeueTableViewCells() as? [LaunchListTableViewCell])
        
        // then
        for i in 0 ..< sut.viewModel.launchViewModels.value.count {
            let cell = cells[i]
            let viewModel = sut.viewModel.launchViewModels.value[i] as! MockLaunchListTableViewCellViewModel
            XCTAssertTrue(viewModel.configuredCell === cell) // pointer equality
        }
    }
    
    func whenDequeueTableViewCells() -> [UITableViewCell] {
        return (0 ..< sut.viewModel.launchViewModels.value.count).map { i in
            let indexPath = IndexPath(row: i, section: 0)
            return sut.tableView(sut.tableView, cellForRowAt: indexPath)
        }
    }
    
    func givenMockViewModels(count: Int = 3) {
        guard count > 0 else {
            sut.viewModel.launchViewModels.accept([])
            return
        }
        sut.viewModel.launchViewModels.accept(givenLaunches(count: count).map { MockLaunchListTableViewCellViewModel(launch: $0) })
    }
    
    func givenViewModels(count: Int = 3) {
        guard count > 0 else {
            sut.viewModel.launchViewModels.accept([])
            return
        }
        sut.viewModel.launchViewModels.accept(givenLaunches(count: count).map { LaunchListTableViewCellViewModel(launch: $0) })
    }
}

class MockLaunchListTableViewCellViewModel: LaunchListTableViewCellViewModel {
    var configuredCell: LaunchListTableViewCell?
    override func configure(_ cell: LaunchListTableViewCell) {
        self.configuredCell = cell
    }
}
