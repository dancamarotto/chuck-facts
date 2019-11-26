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

extension DefaultDataResponse {
    
}

class ServiceAPI {
    
    let network = Network()
    let baseUrl = "https://api.chucknorris.io"
    
    func fetchCategories() -> Single<[String]> {
        let url = "\(baseUrl)/jokes/categories"
        
        return network
            .request(url: url,
                     returnType: [String].self)
    }
    
    func fetchFact(forCategory category: String) -> Single<ChuckFact> {
        let url = "\(baseUrl)/jokes/random"
        let param = ["category" : category]
        
        return network
            .request(url: url,
                     parameters: param,
                     returnType: ChuckFact.self)
    }
}
