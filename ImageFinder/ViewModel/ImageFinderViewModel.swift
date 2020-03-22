//
//  ImageFinderViewModel.swift
//  ImageFinder
//
//  Created by Shivani on 21/03/20.
//  Copyright © 2020 demo. All rights reserved.
//

import Foundation

protocol ImageFinderViewDelegate : class {
    
    func searchResultsDidChange(emptyState: SearchPlaceholderState?)
    
    func searchResultDidError()
}

protocol ImageFinderViewModelProtocol  {
    
    var model: ImageFinderModelProtocol { get set }
    
    var searchQuery: String? { get set }

    var numberOfItems: Int { get }
    
    var delegate: ImageFinderViewDelegate? { get set }
    
    func imageData(at index: Int) -> (title: String?, imageUrl: String?)
    
    func loadMoreImages()
    
    init(model: ImageFinderModelProtocol)
}


class ImageFinderViewModel: ImageFinderViewModelProtocol {
    
    weak var delegate: ImageFinderViewDelegate?
    
    var model: ImageFinderModelProtocol
    
    var numberOfItems: Int {
        return model.numberOfImages()
    }
    
    var searchQuery: String? {
        didSet {
            pageCount = 1
        }
    }
    
    var pageCount: Int = 0 {
        didSet {
        // Loads images everytime page count changes
         getImages()
        }
    }

// MARK: - Utility
    
    func imageData(at index: Int) -> (title: String?, imageUrl: String?) {
        
        guard let data = model.photoData(at: index) else { return (nil, nil) }
        return (data.title, getImageUrl(for: data))
    }
    
    func loadMoreImages() {
           pageCount += 1
       }
    
    private func getImageUrl(for photo: PhotoData) -> String {
        return "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id!)_\(photo.secret)_m.jpg"
    }
    
    private func getImages() {
        
        guard let searchQuery = searchQuery, !searchQuery.isEmpty else {
            model.clearImages()
            delegate?.searchResultsDidChange(emptyState: .emptySearch)
            return
        }
        
        model.getImages(forQuery: searchQuery, page: pageCount) { [weak self] (result) in
                          guard let self = self else { return }
                          switch result {
                              
                          case .success(_):
                            self.delegate?.searchResultsDidChange(emptyState: self.numberOfItems == 0 ? .noData : nil)
                          case .failure(let error):
                              print(error)
                              self.delegate?.searchResultDidError()
                              
                          }
                      }
    }
    
// MARK: - Initialization
    
    required init(model: ImageFinderModelProtocol) {
        self.model = model
    }
    
}
