//
//  Request.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import Foundation

private let FLICKRAPIKEY = "6af377dc54798281790fc638f6e4da5e"
//private let FLOCKRHOST = "https://api.flickr.com/services/rest/"

//https://api.flickr.com/services/rest/?
//method=flickr.photos.search&
//api_key=&
//format=json&
//nojsoncallback=1&
//text=kittens

protocol RequestType {
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var urlParams: [String : Any]? { get }
    var headers: [String : String] { get }
    var httpBody: Data? { get }
}

public enum HttpMethod: String {
  case get = "GET"
  case post = "POST"
  case patch = "PATCH"
  case delete = "DELETE"
  case put = "PUT"
}

enum Request {
    private static var baseURL: String {
        "https://api.flickr.com/services/rest/"
    }

    case fetchPhotosList(Int, Int, String)
}

extension Request: RequestType {
    var path: String {
        switch self {
        case .fetchPhotosList:
            return Self.baseURL
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .fetchPhotosList:
            return .get
        }
    }
    
    var urlParams: [String : Any]? {
        switch self {
            
        case .fetchPhotosList(let page, let limit, let searchQuery):
            return ["api_key": FLICKRAPIKEY,
                    "format": "json",
                    "method": "flickr.photos.search",
                    "page": page,
                    "limit": limit,
                    "text": searchQuery]
        }
    }
    
    var headers: [String : String] {
        ["Content-Type": "application/json"]
    }

    var httpBody: Data? {
//        var json: [String: Any]?
//        switch self {
//        case .fetchPhotosList:
//            json = nil
//        }
//
//        if let json = json {
//            return try? JSONSerialization.data(withJSONObject: json)
//        }
        return nil
    }
}
