//
//  RocketDetaiImageCollectionViewCellViewModel.swift
//  SpaceXLaunch
//
//  Created by Poh  Yung Kien on 18/02/2021.
//

import Foundation
import RxCocoa

protocol RocketDetailImageCollectionViewCellViewModelType {
    var imageURL: BehaviorRelay<URL?> { get }
}

class RocketDetailImageCollectionViewCellViewModel: RocketDetailImageCollectionViewCellViewModelType {
    let imageURL = BehaviorRelay<URL?>(value: nil)
    
    init() {}
    
    init(imageURL: URL?) {
        self.imageURL.accept(imageURL)
    }
    
    public func configure(_ cell: RocketDetailImageCollectionViewCell) {
        cell.viewModel = self
        cell.setupListeners()
    }
}
