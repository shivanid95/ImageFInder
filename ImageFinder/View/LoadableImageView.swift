//
//  LoadableImageView.swift
//  ImageFinder
//
//  Created by Shivani on 21/03/20.
//  Copyright © 2020 demo. All rights reserved.
//

import UIKit


class LoadableImageView: UIImageView, Loadable{
    
    var isLoading: Bool = false {
        
        didSet {
            isLoading ? showLoader() : hideLoader()
        }
    }
    
    var url: URL?
 
    func loadImage(url: URL, completion: ((Bool, Error?) -> Void)? = nil) {

        self.url = url        
        isLoading = true
        // Load image Asynchronously
        let theTask = URLSession.shared.dataTask(with: url) {
            data, response, error in
            guard error == nil else {
                completion?(false, error)
                return
            }
            if let response = data {
                DispatchQueue.main.async { [weak self] in
                    guard  self?.url == url else {
                        completion?(false, nil)
                        return
                        
                    }
                    //Sets image
                    let image = UIImage(data: response)
                    self?.image = image
                    completion?(true, nil)
                    self?.isLoading = false
                    
                }
            }
        }
        theTask.resume()
        
    }
}

