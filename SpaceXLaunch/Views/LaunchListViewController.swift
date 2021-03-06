//
//  LaunchListViewController.swift
//  SpaceXLaunch
//
//  Created by Poh  Yung Kien on 16/02/2021.
//

import UIKit
import RxSwift

class LaunchListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    var viewModel: LaunchListViewModelType = LaunchListViewModel()
    var disposeBag: DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupListeners()
    }
    
    func setupListeners() {
        disposeBag = DisposeBag()
        
        viewModel.launchViewModels
            .asDriver()
            .drive(onNext: { [weak self] value in
                guard let strongSelf = self else { return }
                strongSelf.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return max(viewModel.launchViewModels.value.count, 1)
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard viewModel.launchViewModels.value.count > 0 else {
            return UITableViewCell()
        }
        return listingCell(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let rocketName = viewModel.launchViewModels.value[indexPath.row].launch.value?.rocket else { return }
        let rocketDetailVC = RocketDetailViewController.instanceFromStoryboard()
        rocketDetailVC.viewModel = RocketDetailViewModel(rocketName: rocketName)
        navigationController?.pushViewController(rocketDetailVC, animated: true)
    }
    
    private func listingCell(_ tableView: UITableView, _ indexPath: IndexPath) -> LaunchListTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
                                                    "\(LaunchListTableViewCell.self)") as! LaunchListTableViewCell
        let vm = viewModel.launchViewModels.value[indexPath.row]
        vm.configure(cell)
        return cell
    }
}
