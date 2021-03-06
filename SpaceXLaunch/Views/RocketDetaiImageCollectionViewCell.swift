//
//  RocketDetaiImageCollectionViewCell.swift
//  SpaceXLaunch
//
//  Created by Poh  Yung Kien on 18/02/2021.
//

import UIKit
import RxSwift
import AlamofireImage

class RocketDetailImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    var viewModel: RocketDetailImageCollectionViewCellViewModelType = RocketDetailImageCollectionViewCellViewModel()
    var disposeBag: DisposeBag!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupListeners()
    }
    
    func setupListeners() {
        disposeBag = DisposeBag()
        
        viewModel.imageURL
            .asDriver()
            .drive(onNext: { [weak self] value in
                guard let strongSelf = self else { return }
                if let value = value {
                    strongSelf.imageView.af.setImage(withURL: value, completion:  { [weak self] (_) in
                        guard let strongSelf = self else { return }
                        strongSelf.setNeedsLayout()
                    })
                } else {
                    strongSelf.imageView.image = nil
                }
            })
            .disposed(by: disposeBag)
    }
}
