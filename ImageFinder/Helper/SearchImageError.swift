//
//  SearchImageError.swift
//  ImageFinder
//
//  Created by Shivani on 22/03/20.
//  Copyright © 2020 demo. All rights reserved.
//

import Foundation

enum SearchImageError: Error {
    case noData
    case invalidUrl
    case custom(message: String)
}
