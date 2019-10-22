//
//  ServiceAPI.swift
//  chuck-facts
//
//  Created by Danilo Camarotto on 21/10/19.
//  Copyright © 2019 Danilo Camarotto. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class ServiceAPI {
    
    let baseUrl = "https://api.chucknorris.io"
    
    func fetchCategories() -> Single<[String]> {
        let url = "\(baseUrl)/jokes/categories"
        return Single.create { single in
            let request = Alamofire
                .request(url, method: .get)
                .validate()
                .response(completionHandler: { response in
                    if let error = response.error {
                        return single(.error(error))
                    }
                    
                    do {
                        let categories = try JSONDecoder()
                            .decode([String].self, from: response.data ?? Data())
                        single(.success(categories))
                    } catch {
                        single(.error(error))
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func fetchFact(forCategory category: String) -> Single<ChuckFact> {
        let url = "\(baseUrl)/jokes/random"
        let param = ["category" : category]
        return Single.create { single in
            let request = Alamofire
                .request(url, method: .get, parameters: param,
                         encoding: URLEncoding.queryString)
                .validate()
                .response(completionHandler: { response in
                    if let error = response.error {
                        return single(.error(error))
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let category = try decoder
                            .decode(ChuckFact.self, from: response.data ?? Data())
                        single(.success(category))
                    } catch {
                        single(.error(error))
                    }
                })
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
