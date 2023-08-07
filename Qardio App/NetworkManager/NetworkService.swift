//
//  NetworkService.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import Foundation
import UIKit

final class NetworkService {}

/// REST API
extension NetworkService {
    static func loadPhotos(page: Int, limit: Int, searchQuery: String, completion: @escaping (Result<PhotosListResponse, NetworkError>) -> Void) {
        NetworkManager.request(Request.fetchPhotosList(page, limit, searchQuery)) { result in
            DataParser.transform(response: result, completion: completion)
        }
    }
}

///  Load Images
extension NetworkService {
    static func loadImage(fullPath: URL, completion: @escaping (UIImage?) -> Void) {
        let currentQueue = OperationQueue.current?.underlyingQueue ?? DispatchQueue.main
        DispatchQueue.global().async {
            
            var image: UIImage? = nil
            if let data = try? Data(contentsOf: fullPath) {
                image = UIImage(data: data)
            }

            currentQueue.async {
                completion(image)
            }
        }
    }
}
