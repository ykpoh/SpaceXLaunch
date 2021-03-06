//
//  RocketDetailViewModelTests.swift
//  SpaceXLaunchTests
//
//  Created by Poh  Yung Kien on 20/02/2021.
//

import XCTest
@testable import SpaceXLaunch
import RxSwift

class RocketDetailViewModelTests: XCTestCase {
    var sut: RocketDetailViewModel!
    var rocket: Rocket!
    var mockAPIService: MockAPIService!
    var mockViewController: MockRocketDetailViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        mockAPIService = MockAPIService()
        sut = RocketDetailViewModel(rocketName: "rocketName", apiService: mockAPIService)
        givenMockViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        rocket = nil
        mockAPIService = nil
        mockViewController = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func testImageVMs_whenInitRocket_given2Images() {
        // given
        let urls = [
            URL(string: "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png")!,
            URL(string: "https://images2.imgbox.com/40/e3/GypSkayF_o.png")!
        ]
        whenSUTSetFromRocket(flickr_images: urls)
        // then
        XCTAssertEqual(sut.imageVMs.value.count, urls.count)
    }
    
    func testTitle_whenInitRocket_givenTestTitle() {
        let expected = "Test Title"
        whenSUTSetFromRocket(name: expected)
        XCTAssertEqual(sut.title.value, expected)
    }
    
    func testDescription_whenInitRocket_givenTestDescription() {
        let expected = "Test Description"
        whenSUTSetFromRocket(description: expected)
        XCTAssertEqual(sut.description.value, expected)
    }
    
    func testURL_whenInitRocket_givenTestURL() {
        let expected = URL(string: "https://en.wikipedia.org/wiki/Falcon_Heavy")
        whenSUTSetFromRocket(wikipedia: expected)
        XCTAssertEqual(sut.url.value, expected)
    }
    
    func testNotifyError_whenInit() {
        XCTAssertNil(sut.notifyError.value)
    }
    
    func testRocket_whenInitRocket_givenMockRocket() {
        XCTAssertEqual(sut.rocket.value, rocket)
    }
    
    func testTitleCallback_whenUpdated() {
        // given
        let title = "Test title"
        let exp = expectation(for: NSPredicate(block: { (mockViewController, _) -> Bool in
            return (mockViewController as! MockRocketDetailViewController).titleCallback == title
        }), evaluatedWith: mockViewController, handler: nil)
        
        // when
        sut.title.accept(title)
        
        // then
        wait(for: [exp], timeout: 2.0)
    }
    
    func testDescriptionCallback_whenUpdated() {
        // given
        let description = "Test description"
        let exp = expectation(for: NSPredicate(block: { (mockViewController, _) -> Bool in
            return (mockViewController as! MockRocketDetailViewController).descriptionCallback == description
        }), evaluatedWith: mockViewController, handler: nil)
        
        // when
        sut.description.accept(description)
        
        // then
        wait(for: [exp], timeout: 2.0)
    }
    
    func testURLCallback_whenUpdated() {
        // given
        let url = URL(string: "https://en.wikipedia.org/wiki/Falcon_Heavy")
        let exp = expectation(for: NSPredicate(block: { (mockViewController, _) -> Bool in
            return (mockViewController as! MockRocketDetailViewController).urlCallback == url
        }), evaluatedWith: mockViewController, handler: nil)
        
        // when
        sut.url.accept(url)
        
        // then
        wait(for: [exp], timeout: 2.0)
    }
    
    func testImageVMsCallback_whenUpdated() {
        // given
        let exp = expectation(for: NSPredicate(block: { (mockViewController, _) -> Bool in
            return (mockViewController as! MockRocketDetailViewController).imageVMsCallback
        }), evaluatedWith: mockViewController, handler: nil)
        
        // when
        whenGivenImageVMs()
        
        // then
        wait(for: [exp], timeout: 2.0)
    }
    
    func testNotifyErrorCallback_whenUpdated() {
        // given
        let exp = expectation(for: NSPredicate(block: { (mockViewController, _) -> Bool in
            return (mockViewController as! MockRocketDetailViewController).notifyErrorCallback
        }), evaluatedWith: mockViewController, handler: nil)
        
        // when
        sut.notifyError.accept(MockAPIServiceError.permissionDenied)
        
        // then
        wait(for: [exp], timeout: 2.0)
    }
    
    func testButtonTapActionCallback_givenHasURL_whenWikipediaButtonTapped_returnsTrue() {
        // given
        let exp = expectation(for: NSPredicate(block: { (mockViewController, _) -> Bool in
            return (mockViewController as! MockRocketDetailViewController).buttonTapActionCallback
        }), evaluatedWith: mockViewController, handler: nil)
        
        // when
        sut.url.accept(URL(string: "https://en.wikipedia.org/wiki/Falcon_Heavy"))
        sut.buttonTapAction.onNext(())
        
        // then
        wait(for: [exp], timeout: 2.0)
    }
    
    func testButtonTapActionCallback_givenURLIsNil_whenWikipediaButtonTapped_returnsFalse() {
        // given
        let exp = expectation(for: NSPredicate(block: { (mockViewController, _) -> Bool in
            return !(mockViewController as! MockRocketDetailViewController).buttonTapActionCallback
        }), evaluatedWith: mockViewController, handler: nil)
        
        // when
        sut.url.accept(nil)
        sut.buttonTapAction.onNext(())
        
        // then
        wait(for: [exp], timeout: 2.0)
    }
    
    func testFetchRocketSuccess() throws {
        rocket = Rocket(name: "test_name",
                        description: "description",
                        flickr_images: [
                            URL(string: "https://images2.imgbox.com/3c/0e/T8iJcSN3_o.png")!,
                            URL(string: "https://images2.imgbox.com/40/e3/GypSkayF_o.png")!],
                        wikipedia: URL(string: "https://en.wikipedia.org/wiki/Falcon_Heavy"))
        let expected = RocketDetailViewModel(rocket: rocket)
        
        mockAPIService.status = .success
        mockAPIService.mockRocket = rocket
        mockAPIService.mockErrorResponse = nil
        
        sut.fetchRocket(rocketName: "rocketName")
        
        XCTAssertTrue(mockAPIService.isFetchRocket)
        XCTAssertEqual(sut, expected)
    }

    func testFetchLaunchesWithQueryError() throws {
        let expectedError = MockAPIServiceError.permissionDenied
        mockAPIService.status = .error
        mockAPIService.mockRocket = nil
        mockAPIService.mockErrorResponse = expectedError
        
        sut.fetchRocket(rocketName: "rocketName")
        
        XCTAssertTrue(mockAPIService.isFetchRocket)
        XCTAssertNil(sut.title.value)
        XCTAssertNil(sut.description.value)
        XCTAssertNil(sut.url.value)
        XCTAssertNil(sut.rocket.value)
        XCTAssertTrue(sut.imageVMs.value.isEmpty)
        XCTAssertEqual(sut.notifyError.value?.localizedDescription, expectedError.localizedDescription)
    }
    
    func whenSUTSetFromRocket(name: String? = "test_name",
                              description: String? = "description",
                              flickr_images: [URL]? = [URL(string: "https://farm5.staticflickr.com/4599/38583829295_581f34dd84_b.jpg")!, URL(string: "https://farm5.staticflickr.com/4645/38583830575_3f0f7215e6_b.jpg")!],
                              wikipedia: URL? = URL(string: "https://en.wikipedia.org/wiki/Falcon_Heavy")) {
        rocket = Rocket(name: name, description: description, flickr_images: flickr_images, wikipedia: wikipedia)
        sut = RocketDetailViewModel(rocket: rocket)
    }
    
    func whenGivenImageVMs(count: Int = 3) {
        guard count > 0 else {
            sut.imageVMs.accept([])
            return
        }
        
        sut.imageVMs.accept(givenURLs(count: count).map { RocketDetailImageCollectionViewCellViewModel(imageURL: $0) })
    }
    
    private func givenMockViewController() {
        mockViewController = MockRocketDetailViewController()
        mockViewController.viewModel = sut
        mockViewController.loadViewIfNeeded()
    }
}

class MockRocketDetailViewController: UIViewController {
    var viewModel: RocketDetailViewModelType = RocketDetailViewModel()
    var disposeBag: DisposeBag!
    var imageVMsCallback = false
    var buttonTapActionCallback = false
    var notifyErrorCallback = false
    var titleCallback: String?
    var descriptionCallback: String?
    var urlCallback: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupListeners()
    }
    
    func setupListeners() {
        disposeBag = DisposeBag()
        
        viewModel.title
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.titleCallback = $0
            })
            .disposed(by: disposeBag)
        
        viewModel.description
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.descriptionCallback = $0
            })
            .disposed(by: disposeBag)

        viewModel.url
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.urlCallback = $0
            })
            .disposed(by: disposeBag)
        
        viewModel.imageVMs
            .asDriver()
            .drive(onNext: { [weak self] value in
                guard let strongSelf = self else { return }
                strongSelf.imageVMsCallback = true
            })
            .disposed(by: disposeBag)
        
        viewModel.buttonTapAction
            .subscribe(onNext: { [weak self] value in
                guard let strongSelf = self else { return }
                guard let url = strongSelf.viewModel.url.value, UIApplication.shared.canOpenURL(url) else { return }
                strongSelf.buttonTapActionCallback = true
            })
            .disposed(by: disposeBag)
        
        viewModel.notifyError
            .asDriver()
            .drive(onNext: { [weak self] value in
                guard let strongSelf = self, let value = value else { return }
                strongSelf.notifyErrorCallback = true
            })
            .disposed(by: disposeBag)
    }
}

