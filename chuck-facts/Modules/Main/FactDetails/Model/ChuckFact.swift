//
//  ChuckFact.swift
//  chuck-facts
//
//  Created by Danilo Camarotto on 22/10/19.
//  Copyright © 2019 Danilo Camarotto. All rights reserved.
//

import Foundation

struct ChuckFact: Decodable {
    let id: String
    let iconUrl: String
    let url: String
    let value: String
}
