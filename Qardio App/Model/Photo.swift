//
//  Photo.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import UIKit
import ImageCache

final class Photo: Decodable {
    let id: Int
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    
    private var loadedImage: UIImage?
    private var imageLoading = false
    var image: UIImage {
        loadedImage ?? #imageLiteral(resourceName: "Placeholder")
    }
    
    private var fullPath: URL? {
        URL(string:"http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(key: .id)
        owner = try container.decode(key: .owner)
        secret = try container.decode(key: .secret)
        server = try container.decode(key: .server)
        farm = try container.decode(key: .farm)
        title = try container.decode(key: .title)
    }
    
    func loadImageIfNeeded(_ completion: @escaping () -> Void) {
        if loadedImage == nil,
           imageLoading == false,
           let fullPath {
            imageLoading = true
            ImageCache.shared.load(url: fullPath) { [weak self] url, image in
                self?.imageLoading = false
                self?.loadedImage = image
                completion()
            }
        }
    }
}
