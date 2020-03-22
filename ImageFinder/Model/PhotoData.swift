//
//  PhotoData.swift
//  ImageFinder
//
//  Created by Shivani on 21/03/20.
//  Copyright © 2020 demo. All rights reserved.
//

import Foundation

struct PhotoData: Codable {
    
    var id: String?
    var owner: String?
    var secret: String
    var farm: Int
    var server: String
    var title: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id, owner, secret, farm, server, title
    }
    
}
