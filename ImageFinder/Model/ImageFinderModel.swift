//
//  ImageFinderModel.swift
//  ImageFinder
//
//  Created by Shivani on 21/03/20.
//  Copyright © 2020 demo. All rights reserved.
//

import Foundation

protocol ImageFinderModelProtocol {
    func getImages(forQuery query: String, page: Int, completion: @escaping (Result<Bool, Error>) -> Void )
    func clearImages()
    func numberOfImages() -> Int
    func photoData(at index: Int) -> PhotoData?
}

class ImageFinderModel: ImageFinderModelProtocol {
    
    private var images: [PhotoData] = []
    
    private enum Constants {
        static let searchUrlString = "https://api.flickr.com/services/rest/"
    }
    
    func getImages(forQuery query: String, page: Int, completion: @escaping (Result<Bool, Error>) -> Void ) {
        
        var urlComponents = URLComponents(string: Constants.searchUrlString)
        urlComponents?.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: "062a6c0c49e4de1d78497d13a7dbb360"),
            URLQueryItem(name: "text", value: query),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "per_page", value: "6"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = urlComponents?.url else {
            completion(.failure(SearchImageError.invalidUrl))
            return
            
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil , let data = data else {
                completion(.failure(error!))
                return
            }
     
            do {
                let decodedResponse = try JSONDecoder().decode(SearchResponseData.self, from: data)
                
                guard let photos = decodedResponse.photos else {
                    completion(.failure(SearchImageError.noData))
                    return }
                
                if photos.page == 1 {
                    self.images = photos.photo ?? []
                }
                else {
                    self.images.append(contentsOf: photos.photo!)
                }
                completion(.success(true))
                
            }
            catch let error {
                completion(.failure(SearchImageError.custom(message: error.localizedDescription)))
                print(error)
            }
            
            
        }.resume()
        
    }
    
    func numberOfImages() -> Int {
        
        return images.count
    }
    
    func clearImages() {
        
        images = []
    }
    
    func photoData(at index: Int) -> PhotoData? {
        
        guard index < images.count else { return nil }
        return images[index]
    }
}
