//
//  SearchPlaceholderState.swift
//  ImageFinder
//
//  Created by Shivani on 22/03/20.
//  Copyright © 2020 demo. All rights reserved.
//

import Foundation

enum SearchPlaceholderState {
    // When search result returns empty / no data
    case noData
    
    //When there is no text to search
    case emptySearch
    
    // If any error occurs while fetching search results
    case error
    
    var message: String {
        switch self {
        case .emptySearch:
            return "Please type something to see results"
            
        case .noData:
            return "No search results found"
            
        case .error:
            return "Something went wrong."
        }
    }
}
