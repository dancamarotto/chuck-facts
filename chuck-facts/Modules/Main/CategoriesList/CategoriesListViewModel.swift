//
//  CategoriesListViewModel.swift
//  chuck-facts
//
//  Created by Danilo Camarotto on 21/10/19.
//  Copyright © 2019 Danilo Camarotto. All rights reserved.
//

import Foundation
import RxSwift

class CategoriesListViewModel {
    
    // MARK: - Private properties
    
    private let api = ServiceAPI()
    private let bag = DisposeBag()
    
    // MARK: - Bindable properties
    
    private let categoriesSubject = PublishSubject<[Category]>()
    private let isLoadingSubject = PublishSubject<Bool>()
    private let fetchErrorSubject = PublishSubject<Error>()
    
    var categories: Observable<[Category]> {
        return categoriesSubject.asObservable()
    }
    var isLoading: Observable<Bool> {
        return isLoadingSubject.asObservable()
    }
    var fetchError: Observable<Error> {
        return fetchErrorSubject.asObservable()
    }
    
    // MARK: - Instance functions
    
    func fetchCategories(fromRefreshControl: Bool = false) {
        if !fromRefreshControl {
            isLoadingSubject.onNext(true)
        }
        api.fetchCategories()
            .subscribe(onSuccess: { [weak self] categories in
                self?.isLoadingSubject.onNext(false)
                self?.categoriesSubject
                    .onNext(categories.map { Category(name: $0) })
            }) { [weak self] error in
                self?.isLoadingSubject.onNext(false)
                self?.fetchErrorSubject.onNext(error)
        }.disposed(by: bag)
    }
}
