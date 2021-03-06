//
//  RocketDetailViewModel.swift
//  SpaceXLaunch
//
//  Created by Poh  Yung Kien on 18/02/2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol RocketDetailViewModelType {
    var imageVMs: BehaviorRelay<[RocketDetailImageCollectionViewCellViewModel]> { get }
    var title: BehaviorRelay<String?> { get }
    var description: BehaviorRelay<String?> { get }
    var url: BehaviorRelay<URL?> { get }
    var buttonTapAction: PublishSubject<Void> { get }
    var notifyError: BehaviorRelay<Error?> { get }
    var rocket: BehaviorRelay<Rocket?> { get }
    
    func fetchRocket(rocketName: String)
}

class RocketDetailViewModel: RocketDetailViewModelType {
    let apiService: APIServiceProtocol
    
    let imageVMs = BehaviorRelay<[RocketDetailImageCollectionViewCellViewModel]>(value: [])
    let title = BehaviorRelay<String?>(value: nil)
    let description = BehaviorRelay<String?>(value: nil)
    let url = BehaviorRelay<URL?>(value: nil)
    let buttonTapAction = PublishSubject<Void>()
    let notifyError = BehaviorRelay<Error?>(value: nil)
    let rocket = BehaviorRelay<Rocket?>(value: nil)
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    convenience init(rocketName: String, apiService: APIServiceProtocol = APIService()) {
        self.init(apiService: apiService)
        fetchRocket(rocketName: rocketName)
    }
    
    convenience init(rocket: Rocket, apiService: APIServiceProtocol = APIService()) {
        self.init(apiService: apiService)
        processFetchedRockets(rocket: rocket)
    }
    
    func fetchRocket(rocketName: String) {
        _ = apiService.fetchRocket(rocketName: rocketName, completion: { [weak self] (rocket, error, _) in
            guard let strongSelf = self else { return }
            
            if let rocket = rocket {
                strongSelf.processFetchedRockets(rocket: rocket)
            } else if let error = error {
                strongSelf.notifyError.accept(error)
            }
        })
    }
    
    func processFetchedRockets(rocket: Rocket) {
        title.accept(rocket.name)
        description.accept(rocket.description)
        url.accept(rocket.wikipedia)
        
        imageVMs.accept({ () -> [RocketDetailImageCollectionViewCellViewModel] in
            return (rocket.flickr_images?.compactMap({ (url) -> RocketDetailImageCollectionViewCellViewModel? in
                return RocketDetailImageCollectionViewCellViewModel(imageURL: url)
            }) ?? [])
        }())
        
        self.rocket.accept(rocket)
    }
}

extension RocketDetailViewModel: Equatable {
    static func == (lhs: RocketDetailViewModel, rhs: RocketDetailViewModel) -> Bool {
        return lhs.rocket.value == rhs.rocket.value
    }
}
