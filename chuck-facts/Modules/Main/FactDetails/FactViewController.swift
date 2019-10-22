//
//  FactViewController.swift
//  chuck-facts
//
//  Created by Danilo Camarotto on 22/10/19.
//  Copyright © 2019 Danilo Camarotto. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

class FactViewController: UIViewController {
    
    // MARK: - Outlets and properties
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var factImageView: UIImageView!
    @IBOutlet weak var factLabel: UILabel!
    @IBOutlet weak var nextFactButton: UIButton!
    @IBOutlet weak var openLinkButton: UIButton!
    
    var viewModel: FactViewModel!
    let bag = DisposeBag()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        viewModel.fetchFact()
    }
    
    // MARK: - Actions
    
    @IBAction func openLink(sender: Any) {
        viewModel.openLink()
    }
    
    @IBAction func fetchNextFact(sender: Any) {
        viewModel.fetchFact()
    }
    
    // MARK: - Private functions
    
    private func bindViewModel() {
        viewModel.categoryName
            .subscribe(onNext: { [weak self] category in
                self?.categoryLabel.text = category
        }).disposed(by: bag)
        
        viewModel.fact
            .subscribe(onNext: { [weak self] fact in
                guard let self = self else { return }
                self.update(fact: fact)
        }).disposed(by: bag)
        
        viewModel.isLoading
            .subscribe(onNext: { [weak self] isLoading in
                isLoading ? self?.showLoading() : self?.hideLoading()
        }).disposed(by: bag)
    }
    
    private func update(fact: ChuckFact) {
        DispatchQueue.main.async {
            self.factLabel.text = fact.value
            self.nextFactButton.isHidden = false
            self.openLinkButton.isHidden = false
        }
        if let url = URL(string: fact.iconUrl) {
            factImageView.kf.setImage(with: url)
        }
    }
}
