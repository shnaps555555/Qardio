//
//  NetworkError.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import Foundation

enum NetworkErrorCode: Int, Decodable {
    case noLocationFound = 1006
}


final class NetworkError: Error, Decodable {
    let message: String?
    let code: NetworkErrorCode?
    let details: String?
    
    init(title: String? = nil, details: String? = nil) {
        self.message = title
        self.details = details
        code = nil
    }
}

extension NetworkError {
    static var unknown: NetworkError {
        .init(title: NSLocalizedString("Error", comment: ""),
              details: NSLocalizedString("Unknown error", comment: ""))
    }
    
    static var validation: NetworkError {
        .init(title: NSLocalizedString("Error", comment: ""),
              details: NSLocalizedString("Data validation failed", comment: ""))
    }

    static var networkProblem: NetworkError {
        .init(title: NSLocalizedString("Error", comment: ""),
              details: NSLocalizedString("Failed to retrieve data from network", comment: ""))
    }
}
