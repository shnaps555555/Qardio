//
//  PhotosListResponse.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import UIKit

final class PhotosListResponse: Decodable {
    let photos: PhotoPage
    let stat: String
    
    enum CodingKeys: String, CodingKey {
        case photos
        case stat
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        photos = try container.decode(key: .photos)
        stat = try container.decode(key: .stat)
    }
}

final class PhotoPage: Decodable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perpage
        case total
        case photo
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decode(key: .page)
        pages = try container.decode(key: .pages)
        perpage = try container.decode(key: .perpage)
        total = try container.decode(key: .total)
        photo = try container.decode(key: .photo)
    }
}
