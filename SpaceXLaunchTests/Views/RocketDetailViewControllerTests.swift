//
//  RocketDetailViewControllerTests.swift
//  SpaceXLaunchTests
//
//  Created by Poh  Yung Kien on 21/02/2021.
//

import XCTest
@testable import SpaceXLaunch

class RocketDetailViewControllerTests: XCTestCase {
    var sut: RocketDetailViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = RocketDetailViewController.instanceFromStoryboard()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }
    
    func testCollectionViewNumberOfItemsInSection_whenInit_return0() {
        // given
        let expected = 0
        // when
        let actual = sut.collectionView(sut.collectionView, numberOfItemsInSection: 0)
        // then
        XCTAssertEqual(actual, expected)
    }
    
    func testCollectionViewNumberOfItemsInSection_givenHasViewModels_returnViewModelsCount() {
        // given
        let expected = 3
        givenViewModels(count: expected)
        // when
        let actual = sut.collectionView(sut.collectionView, numberOfItemsInSection: 0)
        // then
        XCTAssertEqual(actual, expected)
    }
    
    func testCollectionViewSizeForItem_whenInit() {
        // given
        let expected = CGSize(width: UIScreen.main.bounds.width, height: 315)
        // when
        let actual = sut.collectionView(sut.collectionView, layout: UICollectionViewLayout(), sizeForItemAt: IndexPath(item: 0, section: 0))
        // then
        XCTAssertEqual(actual, expected)
    }
    
    func testCollectionViewCellForRowAt_givenViewModelsSet_returnsRocketDetailImageCollectionViewCell() {
        // given
        givenViewModels()
        
        // when
        let cells = whenDequeueCollectionViewCells()
        
        // then
        for cell in cells {
            XCTAssertTrue(cell is RocketDetailImageCollectionViewCell)
        }
    }
    
    func testCollectionViewCellForRowAt_givenViewModelsSet_configuresTableViewCells() throws {
        // given
        givenMockViewModels()
        
        // when
        let cells = try XCTUnwrap(whenDequeueCollectionViewCells() as? [RocketDetailImageCollectionViewCell])
        
        // then
        for i in 0 ..< sut.viewModel.imageVMs.value.count {
            let cell = cells[i]
            let viewModel = sut.viewModel.imageVMs.value[i] as! MockRocketDetailImageCollectionViewCellViewModel
            XCTAssertTrue(viewModel.configuredCell === cell) // pointer equality
        }
    }
    
    func givenViewModels(count: Int = 3) {
        guard count > 0 else {
            sut.viewModel.imageVMs.accept([])
            return
        }
        
        sut.viewModel.imageVMs.accept(givenURLs(count: count).map { RocketDetailImageCollectionViewCellViewModel(imageURL: $0) })
    }
    
    func givenMockViewModels(count: Int = 3) {
        guard count > 0 else {
            sut.viewModel.imageVMs.accept([])
            return
        }
        sut.viewModel.imageVMs.accept(givenURLs(count: count).map { MockRocketDetailImageCollectionViewCellViewModel(imageURL: $0) })
    }
    
    func whenDequeueCollectionViewCells() -> [UICollectionViewCell] {
        return (0 ..< sut.viewModel.imageVMs.value.count).map { i in
            let indexPath = IndexPath(row: i, section: 0)
            return sut.collectionView(sut.collectionView, cellForItemAt: indexPath)
        }
    }
}

class MockRocketDetailImageCollectionViewCellViewModel: RocketDetailImageCollectionViewCellViewModel {
    var configuredCell: RocketDetailImageCollectionViewCell?
    override func configure(_ cell: RocketDetailImageCollectionViewCell) {
        self.configuredCell = cell
    }
}
