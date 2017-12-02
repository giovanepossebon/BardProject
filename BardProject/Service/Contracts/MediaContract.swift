//
//  MediaContract.swift
//  BardProject
//
//  Created by Giovane Possebon on 2/12/17.
//  Copyright © 2017 bard. All rights reserved.
//

import Foundation

protocol MediaContract {
    static func getMedia(request: MediaServiceRequest, callback: @escaping (Response<Media>) -> ())
}
