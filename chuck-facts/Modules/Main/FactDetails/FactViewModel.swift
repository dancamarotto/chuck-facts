//
//  FactViewModel.swift
//  chuck-facts
//
//  Created by Danilo Camarotto on 22/10/19.
//  Copyright © 2019 Danilo Camarotto. All rights reserved.
//

import Foundation
import RxSwift

class FactViewModel {
    
    // MARK: - Private properties
    
    private let category: Category
    private let api = ServiceAPI()
    private let bag = DisposeBag()
    private var chuckFact: ChuckFact?
    
    // MARK: - Initializers
    
    init(_ category: Category) {
        self.category = category
    }
    
    // MARK: - Bindable properties
    
    private let factSubject = PublishSubject<ChuckFact>()
    private let categorySubject = PublishSubject<String>()
    private let isLoadingSubject = PublishSubject<Bool>()
    private let fetchErrorSubject = PublishSubject<String>()
    
    var fact: Observable<ChuckFact> {
        return factSubject.asObservable()
    }
    var categoryName: Observable<String> {
        return categorySubject.asObservable()
    }
    var isLoading: Observable<Bool> {
        return isLoadingSubject.asObservable()
    }
    var fetchError: Observable<String> {
        return fetchErrorSubject.asObservable()
    }
    
    // MARK: - Instance functions
    
    func fetchFact() {
        isLoadingSubject.onNext(true)
        api.fetchFact(forCategory: category.name)
            .subscribe(onSuccess: { [weak self] fact in
                guard let self = self else { return }
                self.isLoadingSubject.onNext(false)
                self.chuckFact = fact
                self.categorySubject.onNext(self.category.name)
                self.factSubject.onNext(fact)
            }) { [weak self] _ in
                let message = "We had a problem fetching your data, please try again later."
                self?.isLoadingSubject.onNext(false)
                self?.fetchErrorSubject.onNext(message)
        }.disposed(by: bag)
    }
    
    func openLink() {
        guard let chuckFact = chuckFact,
            let url = URL(string: chuckFact.url) else {
                let error = "Link could not be opened, try again later."
                fetchErrorSubject.onNext(error)
                return
        }
        UIApplication.shared.open(url)
    }
}
