//
//  Media.swift
//  BardProject
//
//  Created by Giovane Possebon on 2/12/17.
//  Copyright © 2017 bard. All rights reserved.
//

import Foundation

struct Media: Codable {
    let artefacts: [URL]
    let animated: Bool

    enum CodingKeys: String, CodingKey {
        case artefacts = "Artefact"
        case animated = "Animated"
    }
}
