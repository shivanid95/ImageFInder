//
//  SearchResponseData.swift
//  ImageFinder
//
//  Created by Shivani on 21/03/20.
//  Copyright © 2020 demo. All rights reserved.
//

import Foundation

struct SearchResponseData: Codable {
    
    
    var photos: SearchPhotosData?
    
    struct SearchPhotosData: Codable {
        var page: Int
           var pages: Int
           var perpage: Int
           var photo: [PhotoData]?
           
          private enum CodingKeys: String, CodingKey {
               case page, pages, perpage, photo
           }
    }
    
    enum CodingKeys: String, CodingKey {
        case photos
    }
   
}
