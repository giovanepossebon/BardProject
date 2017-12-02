//
//  BardApi.swift
//  BardProject
//
//  Created by Giovane Possebon on 2/12/17.
//  Copyright © 2017 bard. All rights reserved.
//

import Foundation

struct BardAPI {

    // API Configs, keys, etc

    struct url {
        static let baseURL = "http://ec2-54-202-16-95.us-west-2.compute.amazonaws.com/api/"
    }

}

struct Response<T> {
    var data: T?
    let result: Result
}

enum Result {
    case success
    case error(message: String)
}
