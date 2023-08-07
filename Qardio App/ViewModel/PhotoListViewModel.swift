//
//  PhotoListViewModel.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import UIKit

final class PhotoListViewModel: NSObject {

    private(set) var photos: [Photo] = []
    
    func loadPhotos(_ completion: @escaping () -> Void) {
        NetworkService.loadPhotos(page: 1, limit: 100, searchQuery: "Ocean") { [weak self] result in
            switch result {
            case .success(let list):
                self?.photos = list.photos.photo
            case .failure(let failure):
                print(failure.message?.description)
            }
            
            completion()
        }
    }
    
    
}
