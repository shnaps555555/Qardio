//
//  PhotoListViewController.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import UIKit
import ImageCache

final class PhotoListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkService.loadPhotos(page: 1, limit: 10, searchQuery: "tele") { result in
            switch result {
            case .success(let success):
                print(success.photos.photo.count)
                
                if let photoUrl = success.photos.photo.first?.fullPath {
                    ImageCache.shared.load(url: photoUrl) { url, image in
                        
                    }
                }
            case .failure(let failure):
                print(failure.message)
            }
        }
    }
    
    
}
