//
//  PhotoListViewModel.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import UIKit

final class PhotoListViewModel: NSObject {

    private(set) var photos: [Photo] = []
    private(set) var isLoading = false
    private let defaultSearchQuery = "Ocean" // required by FLICKR
    private var page = 0
    
    var willLoadHandler: (() -> Void)?
    var didLoadHandler: (() -> Void)?
    
    var searchQuery: String? {
        didSet {
            page = 0
        }
    }
    
    func loadPhotos() {
        willLoadHandler?()
        
        isLoading = true
        page += 1
        NetworkService.loadPhotos(page: page,
                                  limit: 100,
                                  searchQuery: (searchQuery.isNilOrEmpty ? defaultSearchQuery : searchQuery!)) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let list):
                if self.page == 1 {
                    self.photos = list.photos.photo
                } else {
                    self.photos.append(contentsOf: list.photos.photo)
                }
            case .failure(let failure):
                print(failure.message?.description ?? "response error") // TO DO Disply alert
            }
            
            self.isLoading = false
            self.didLoadHandler?()
        }
    }
    
    
}
