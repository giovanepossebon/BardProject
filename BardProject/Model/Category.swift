//
//  Category.swift
//  BardProject
//
//  Created by Giovane Possebon on 2/12/17.
//  Copyright © 2017 bard. All rights reserved.
//

import Foundation

struct Category: Codable {
    let id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case title = "Name"
    }
}
