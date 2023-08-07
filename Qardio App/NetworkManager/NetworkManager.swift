//
//  NetworkManager.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import Foundation

final class NetworkManager {
    static func request(_ request: RequestType, completion: @escaping (Result<Data, Error>) -> Void) {
        let session = URLSession.shared
        guard var urlComponents = URLComponents(string: request.path) else {
            assertionFailure("Failed to get URLComponents from URL path")
            completion(.failure(NetworkError.unknown))
            return
        }
        // Add parameters to URL
        if let urlParams = request.urlParams, !urlParams.isEmpty {
            urlComponents.queryItems = []
            urlParams.keys.forEach { key in
                if let value = urlParams[key] {
                    urlComponents.queryItems?.append(
                        URLQueryItem(name: key, value: "\(value)")
                    )
                }
            }
        }
        guard let url = urlComponents.url else {
            assertionFailure("Failed to construct URL")
            completion(.failure(NetworkError.unknown))
            return
        }
        var urlRequest = URLRequest(url: url, timeoutInterval: 30)
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.httpBody = request.httpBody
        print(urlRequest)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard
                let data, // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                response.status?.responseType == .success,    // is statusCode 2XX
                error == nil                                  // is there no error
            else {
                if let data {
                    completion(.success(data))
                } else {
                    completion(.failure(NetworkError(title: error?.localizedDescription)))
                }
                return
            }
            completion(.success(data))
        })
        task.resume()
    }
}

