//
//  LaunchListTableViewCellViewModelTests.swift
//  SpaceXLaunchTests
//
//  Created by Poh  Yung Kien on 21/02/2021.
//

import XCTest
@testable import SpaceXLaunch

class LaunchListTableViewCellViewModelTests: XCTestCase {
    var sut: LaunchListTableViewCellViewModel!
    var cell: LaunchListTableViewCell!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        whenSUTSetFromLaunch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cell = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func testConfigureCell_setsLaunchLabelText() {
        // when
        whenConfigureLaunchListTableViewCell()
        
        // then
        XCTAssertEqual(cell.launchNumberLabel.text, sut.launchNumber.value)
    }
    
    func testConfigureCell_setsDetailLabelText() {
        // when
        whenConfigureLaunchListTableViewCell()
        
        // then
        XCTAssertEqual(cell.detailLabel.text, sut.detail.value)
    }
    
    func testHideDetailLabel_givenDetailsIsNil_whenConfigureCell() {
        // when
        whenSUTSetFromLaunch(details: nil)
        whenConfigureLaunchListTableViewCell()
        
        // then
        XCTAssertTrue(cell.detailLabel.isHidden)
    }
    
    func testConfigureCell_setsDateTimeLabelText() {
        // when
        whenConfigureLaunchListTableViewCell()
        
        // then
        XCTAssertEqual(cell.dateLabel.text, sut.dateTime.value)
    }
    
    func testConfigureCell_setsStatusLabelText() {
        // when
        whenConfigureLaunchListTableViewCell()
        
        // then
        XCTAssertEqual(cell.statusLabel.text, sut.statusString.value)
    }
    
    func testStatusLabelTextColor_givenUpcomingIsTrue_whenConfigureCell() {
        // when
        whenSUTSetFromLaunch(upcoming: true)
        whenConfigureLaunchListTableViewCell()
        
        // then
        XCTAssertEqual(cell.statusLabel.textColor, .brown)
    }
    
    func testStatusLabelTextColor_givenSuccessIsTrue_whenConfigureCell() {
        // when
        whenSUTSetFromLaunch(success: true)
        whenConfigureLaunchListTableViewCell()
        
        // then
        XCTAssertEqual(cell.statusLabel.textColor, .green)
    }
    
    func testStatusLabelTextColor_givenBothUpcomingAndSuccessAreFalse_whenConfigureCell() {
        // when
        whenConfigureLaunchListTableViewCell()
        
        // then
        XCTAssertEqual(cell.statusLabel.textColor, .red)
    }
    
    func whenSUTSetFromLaunch(
        id: String = "id",
        name: String = "name",
        details: String? = "details",
        date_utc: Date = Date().addingTimeInterval(100),
        upcoming: Bool = false,
        success: Bool = false,
        rocket: String = "rocket") {
        sut = LaunchListTableViewCellViewModel(launch: Launch(id: id, name: name, details: details, date_utc: date_utc, upcoming: upcoming, success: success, rocket: rocket))
    }
    
    func givenLaunchListTableViewCell() {
        let viewController = LaunchListViewController.instanceFromStoryboard()
        viewController.loadViewIfNeeded()
        
        let tableView = viewController.tableView!
        cell = tableView.dequeueReusableCell(withIdentifier: "\(LaunchListTableViewCell.self)") as? LaunchListTableViewCell
    }

    // MARK: - When
    func whenConfigureLaunchListTableViewCell() {
        givenLaunchListTableViewCell()
        sut.configure(cell)
    }
}
