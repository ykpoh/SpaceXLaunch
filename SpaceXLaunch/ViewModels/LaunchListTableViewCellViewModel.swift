//
//  LaunchListTableViewCellViewModel.swift
//  SpaceXLaunch
//
//  Created by Poh  Yung Kien on 17/02/2021.
//

import Foundation
import RxCocoa

protocol LaunchListTableViewCellViewModelType {
    var launch: BehaviorRelay<Launch?> { get }
    var launchNumber: BehaviorRelay<String?> { get }
    var detail: BehaviorRelay<String?> { get }
    var hideDetail: BehaviorRelay<Bool> { get }
    var dateTime: BehaviorRelay<String?> { get }
    var statusString: BehaviorRelay<String?> { get }
    var statusTextColor: BehaviorRelay<UIColor> { get }
    
    init(launch: Launch)
}

class LaunchListTableViewCellViewModel: LaunchListTableViewCellViewModelType {
    enum Status: String {
        case upcoming = "UPCOMING"
        case success = "SUCCESS"
        case fail = "FAIL"
    }
    var launch = BehaviorRelay<Launch?>(value: nil)
    var launchNumber = BehaviorRelay<String?>(value: nil)
    var detail = BehaviorRelay<String?>(value: nil)
    var hideDetail = BehaviorRelay<Bool>(value: false)
    var dateTime = BehaviorRelay<String?>(value: nil)
    var statusString = BehaviorRelay<String?>(value: nil)
    var statusTextColor = BehaviorRelay<UIColor>(value: .black)
    var status: Status = .upcoming
    
    init() {}
    
    required convenience init(launch: Launch) {
        self.init()
        self.launch.accept(launch)
        launchNumber.accept(launch.name)
        detail.accept(launch.details)
        hideDetail.accept(launch.details == nil)
        if let date = launch.date_utc {
            dateTime.accept("Launch time: \(DateFormatter.dateTimeSeconds.string(from: date)) (UTC)")
        } else {
            dateTime.accept("Launch time: TBD")
        }
        status = { () -> (Status) in
            if launch.upcoming ?? false {
                return .upcoming
            } else if launch.success ?? false {
                return .success
            } else {
                return .fail
            }
        }()
        statusString.accept(status.rawValue)
        statusTextColor.accept({ () -> UIColor in
            switch status {
            case .upcoming:
                return .brown
            case .success:
                return .green
            case .fail:
                return .red
            }
        }())
    }
    
    public func configure(_ cell: LaunchListTableViewCell) {
        cell.viewModel = self
        cell.setupListeners()
    }
}

extension LaunchListTableViewCellViewModel: Equatable {
    static func == (lhs: LaunchListTableViewCellViewModel, rhs: LaunchListTableViewCellViewModel) -> Bool {
        return lhs.launch.value == rhs.launch.value
    }
}
