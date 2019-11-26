//
//  Network.swift
//  chuck-facts
//
//  Created by Danilo Camarotto on 25/11/19.
//  Copyright © 2019 Danilo Camarotto. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum NetworkMethod {
    case get, post, put, delete
    
    func httpMethod() -> HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .delete:
            return .delete
        }
    }
}

protocol Networking {
    func request<T: Decodable>(url: String,
                               method: NetworkMethod,
                               parameters: [String : Any]?,
                               returnType: T.Type) -> Single<T>
}

class Network: Networking {
    func request<T: Decodable>(url: String,
                               method: NetworkMethod = .get,
                               parameters: [String : Any]? = nil,
                               returnType: T.Type) -> Single<T> {
        return Single.create { single in
            let request = Alamofire
                .request(url, method: method.httpMethod(), parameters: parameters,
                         encoding: URLEncoding.queryString)
                .validate()
                .response(completionHandler: { response in
                    if let error = response.error {
                        return single(.error(error))
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let object = try decoder
                            .decode(T.self, from: response.data ?? Data())
                        single(.success(object))
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
