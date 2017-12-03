//
//  MediaService.swift
//  BardProject
//
//  Created by Giovane Possebon on 2/12/17.
//  Copyright © 2017 bard. All rights reserved.
//

import Foundation

private struct Endpoint {
    static let getMedia = BardAPI.url.baseURL + "ArtefactClass/GetArtefact"
}

struct MediaServiceRequest {
    let text: String
    let animated: Bool
    let categoryId: Int
    let realData: Bool
}

class MediaService: MediaContract {

    static func getMedia(request: MediaServiceRequest, callback: @escaping (Response<Media>) -> ()) {

        guard let url = URL(string: Endpoint.getMedia) else {
            callback(Response<Media>(data: nil, result: .error(message: "Invalid URL")))
            return
        }

        let params: [String: Any] = [
            "Artefact": request.text,
            "Animated": request.animated,
            "StoryClassId": request.categoryId,
            "GetRealData": request.realData
        ]

        Network.request(url, method: .post, parameters: params) { response in
            switch response.result {
            case .success:
                guard let data = response.data else {
                    callback(Response<Media>(data: nil, result: .error(message: "Invalid data")))
                    return
                }

                do {
                    let media = try JSONDecoder().decode(Media.self, from: data)
                    callback(Response<Media>(data: media, result: .success))
                } catch {
                    callback(Response<Media>(data: nil, result: .error(message: "JSON Serialization failed")))
                    return
                }
            case .failure(let error):
                callback(Response<Media>(data: nil, result: .error(message: error.localizedDescription)))
            }
        }
    }

}
