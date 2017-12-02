//
//  CategoryContract.swift
//  BardProject
//
//  Created by Giovane Possebon on 2/12/17.
//  Copyright © 2017 bard. All rights reserved.
//

import Foundation

protocol CategoryContract {
    static func getCategories(callback: @escaping (Response<[Category]>) -> ())
}
