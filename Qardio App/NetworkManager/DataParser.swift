//
//  DataParser.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import Foundation

// Class for working wiith error in future releases
class ErrorDTO: Decodable {
    let error: NetworkError
}

// Duct tape method for kicking 'jsonFlickrApi' field in the begining of response
private extension String {
  subscript (r: CountableClosedRange<Int>) -> String {
    let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
    let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
    return String(self[startIndex...endIndex])
  }
}

final class DataParser {
    // Decodable as Result
    static func transform<T:Decodable>(response: Result<Data, Error>,
                                       completion: @escaping (Result<T, NetworkError>) -> Void) {
        switch response {
        case .success(let data):
            do {
                var str = String(data: data, encoding: .utf8) // temporary fix for kicking 'jsonFlickrApi' field in the begining of response
                str = str![14...str!.count-2]                 //
                
                let jsonDictionary = try JSONSerialization.jsonObject(with: (str?.data(using: .utf8))!, options: .fragmentsAllowed) as? [AnyHashable: Any]
                
                if let jsonDictionary {
                    print(jsonDictionary)

                    if let finalObject: T = try? decode(from: jsonDictionary) {
                        completeOnMainThread(.success(finalObject), completion: completion)
                    } else {
                        if let error: ErrorDTO = try? decode(from: jsonDictionary) {
                            completeOnMainThread(.failure(error.error), completion: completion)
                        } else {
                            completeOnMainThread(.failure(NetworkError.validation), completion: completion)
                        }
                    }
                } else {
                    completeOnMainThread(.failure(NetworkError.validation), completion: completion)
                }
            } catch {
                completeOnMainThread(.failure(error), completion: completion)
                print(error)
            }
            
        case .failure(let error):
            completeOnMainThread(.failure(error), completion: completion)
        }
    }
    
    private static func decode<T: Decodable>(from data: [AnyHashable: Any]) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private static func completeOnMainThread<T>(_ response: Result<T, Error>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        switch response {
        case .success(let successObject):
            DispatchQueue.main.async {
                completion(.success(successObject))
            }
            
        case .failure(let error):
            var customError = NetworkError.networkProblem
            if error is NetworkError {
                customError = error as! NetworkError
            }
            DispatchQueue.main.async {
                completion(.failure(customError))
            }
        }
    }
}
