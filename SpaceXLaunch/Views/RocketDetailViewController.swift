//
//  RocketDetailViewController.swift
//  SpaceXLaunch
//
//  Created by Poh  Yung Kien on 18/02/2021.
//

import UIKit
import RxSwift

class RocketDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var button: UIButton!
    
    var viewModel: RocketDetailViewModelType = RocketDetailViewModel()
    var disposeBag: DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupCollectionViewLayout()
        setupListeners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        revealNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigationBar()
    }
    
    func revealNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = .white
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func hideNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    func setupCollectionViewLayout() {
        let newLayout = SnappingCollectionViewLayout()
        newLayout.spacingLeft = 0
        newLayout.scrollDirection = .horizontal
        newLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 315)
        collectionView.collectionViewLayout = newLayout
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
    
    func setupListeners() {
        disposeBag = DisposeBag()
        
        button.rx.tap
            .bind(to: viewModel.buttonTapAction)
            .disposed(by: disposeBag)
        
        viewModel.title
            .asDriver()
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.description
            .asDriver()
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.url
            .asDriver()
            .drive(onNext: { [weak self] value in
                guard let strongSelf = self else { return }
                strongSelf.button.isHidden = value == nil
            })
            .disposed(by: disposeBag)
        
        viewModel.imageVMs
            .asDriver()
            .drive(onNext: { [weak self] value in
                guard let strongSelf = self else { return }
                strongSelf.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.buttonTapAction
            .subscribe(onNext: { [weak self] value in
                guard let strongSelf = self else { return }
                guard let url = strongSelf.viewModel.url.value, UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.notifyError
            .asDriver()
            .drive(onNext: { [weak self] value in
                guard let strongSelf = self, let value = value else { return }
                strongSelf.showAlert(value.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageVMs.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 315)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(RocketDetailImageCollectionViewCell.self)", for: indexPath) as! RocketDetailImageCollectionViewCell
        
        // update cell
        let vm = viewModel.imageVMs.value[indexPath.row]
        vm.configure(cell)
        
        return cell
    }
}
