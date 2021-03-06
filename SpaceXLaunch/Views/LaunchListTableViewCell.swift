//
//  LaunchListTableViewCell.swift
//  SpaceXLaunch
//
//  Created by Poh  Yung Kien on 17/02/2021.
//

import UIKit
import RxSwift

class LaunchListTableViewCell: UITableViewCell {
    @IBOutlet var containerView: UIView!
    @IBOutlet var launchNumberLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    var disposeBag: DisposeBag!
    var viewModel: LaunchListTableViewCellViewModelType = LaunchListTableViewCellViewModel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupListeners()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = nil
    }
    
    private func setupViews() {
        selectionStyle = .none
    }
    
    func setupListeners() {
        disposeBag = DisposeBag()
        
        viewModel.launchNumber
            .asDriver()
            .drive(launchNumberLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.detail
            .asDriver()
            .drive(detailLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.hideDetail
            .asDriver()
            .drive(onNext: { [weak self] value in
                guard let strongSelf = self else { return }
                strongSelf.detailLabel.isHidden = value
            })
            .disposed(by: disposeBag)
        
        viewModel.dateTime
            .asDriver()
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.statusString
            .asDriver()
            .drive(statusLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.statusTextColor
            .asDriver()
            .drive(onNext: { [weak self] value in
                guard let strongSelf = self else { return }
                strongSelf.statusLabel.textColor = value
            })
            .disposed(by: disposeBag)
    }
}
