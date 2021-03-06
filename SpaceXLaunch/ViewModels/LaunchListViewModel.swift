//
//  LaunchListViewModel.swift
//  SpaceXLaunch
//
//  Created by Poh  Yung Kien on 16/02/2021.
//

import Foundation
import RxCocoa

protocol LaunchListViewModelType {
    var launchViewModels: BehaviorRelay<[LaunchListTableViewCellViewModel]> { get }
    var notifyError: BehaviorRelay<Error?> { get }
    
    func fetchLaunchesWithQuery()
}

class LaunchListViewModel: LaunchListViewModelType {
    let apiService: APIServiceProtocol
    
    var launchViewModels = BehaviorRelay<[LaunchListTableViewCellViewModel]>(value: [])
    var notifyError = BehaviorRelay<Error?>(value: nil)
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
        fetchLaunchesWithQuery()
    }
    
    func fetchLaunchesWithQuery() {
        apiService.fetchLaunchesWithQuery { [weak self] (launchResponse, error, _) in
            guard let strongSelf = self else { return }
            
            if let launchResponse = launchResponse {
                strongSelf.processFetchedLaunches(launchResponse: launchResponse)
            } else if let error = error {
                strongSelf.notifyError.accept(error)
            }
        }
    }
    
    func processFetchedLaunches(launchResponse: LaunchResponse) {
        guard let launches = launchResponse.docs else { return }
        launchViewModels.accept(convertLaunchesToLaunchListTableViewCellViewModels(launches: launches))
    }
    
    func convertLaunchesToLaunchListTableViewCellViewModels(launches: [Launch]) -> [LaunchListTableViewCellViewModel] {
        var launchListTableViewCellViewModels: [LaunchListTableViewCellViewModel] = []
        for launch in launches {
            launchListTableViewCellViewModels.append(LaunchListTableViewCellViewModel(launch: launch))
        }
        return launchListTableViewCellViewModels
    }
}
