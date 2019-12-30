//
//  CategoriesListViewController.swift
//  chuck-facts
//
//  Created by Danilo Camarotto on 21/10/19.
//  Copyright © 2019 Danilo Camarotto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol CategoriesListViewControllerDelegate: class {
    func didSelectCategory(_ category: Category)
}

class CategoriesListViewController: UIViewController {
    
    // MARK: - Outlets and properties
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = CategoriesListViewModel()
    private let bag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    weak var delegate: CategoriesListViewControllerDelegate?
    
    static let viewIdentifier = "CategoriesListView"
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UI
        setupRefreshControl()
        
        // Bind UI
        bindViewModel()
        
        // Fetch data
        viewModel.fetchCategories()
    }

    // MARK: - Private functions
    
    private func bindViewModel() {
        viewModel.isLoading
            .subscribe(onNext: { [weak self] isLoading in
                isLoading ? self?.showLoading() : self?.hideLoading()
                self?.changeRefreshControlState(isLoading: isLoading)
        }).disposed(by: bag)
        
        viewModel.categories
            .bind(to: tableView.rx
                .items(cellIdentifier: CategoryTableViewCell.identifier,
                       cellType: CategoryTableViewCell.self)) { row, category, cell in
                        cell.setup(category)
        }.disposed(by: bag)
        
        viewModel.fetchError
            .subscribe(onNext: { [weak self] _ in
                self?.showFetchDataError()
        }).disposed(by: bag)
        
        // RxCocoa
        
        tableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: bag)
        
        tableView.rx
            .modelSelected(Category.self)
            .subscribe { [weak self] category in
                guard let category = category.element else { return }
                self?.delegate?.didSelectCategory(category)
//                self?.performSegue(withIdentifier: "FactDetailView",
//                                   sender: category)
        }.disposed(by: bag)
    }
    
    private func showFetchDataError() {
        let message = "We had a problem fetching your data, please try again later."
        showDefaultError(withMessage: message)
    }
    
    private func setupRefreshControl() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshCategoriesData), for: .valueChanged)
        refreshControl.tintColor = .darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Categories...")
    }
    
    private func changeRefreshControlState(isLoading: Bool) {
        if !isLoading {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc private func refreshCategoriesData() {
        viewModel.fetchCategories(fromRefreshControl: true)
    }
}

//extension CategoriesListViewController {
//
//    // MARK: - Navigation
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? FactViewController,
//            let category = sender as? Category {
//            let viewModel = FactViewModel(category)
//            vc.viewModel = viewModel
//        }
//    }
//}
