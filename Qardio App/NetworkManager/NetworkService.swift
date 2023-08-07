//
//  NetworkService.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import Foundation

final class NetworkService {}

extension NetworkService {
    static func loadPhotos(page: Int, limit: Int, searchQuery: String, completion: @escaping (Result<PhotosListResponse, NetworkError>) -> Void) {
        NetworkManager.request(Request.fetchPhotosList(page, limit, searchQuery)) { result in
            DataParser.transform(response: result, completion: completion)
        }
    }
}

