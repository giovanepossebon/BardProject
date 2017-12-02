//
//  CategoryService.swift
//  BardProject
//
//  Created by Giovane Possebon on 2/12/17.
//  Copyright © 2017 bard. All rights reserved.
//

import Foundation

private struct Endpoint {
    static let categories = "ArtefactClass/GetAvailableStoryTypes"
}

class CategoryService: CategoryContract {

    static func getCategories(callback: @escaping (Response<[Category]>) -> ()) {
        guard let url = URL(string: "\(BardAPI.url.baseURL + Endpoint.categories)") else {
            callback(Response<[Category]>(data: [], result: .error(message: "Invalid URL")))
            return
        }

        Network.request(url, method: .get) { response in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    callback(Response<[Category]>(data: [], result: .error(message: "Problem with Serialization")))
                    return
                }

                do {
                    let categories = try JSONDecoder().decode([Category].self, from: data)
                    callback(Response<[Category]>(data: categories, result: .success))
                } catch {
                    callback(Response<[Category]>(data: [], result: .error(message: "Problem with Serialization")))
                }
            case .failure(let error):
                callback(Response<[Category]>(data: [], result: .error(message: error.localizedDescription)))
            }
        }
    }

}
