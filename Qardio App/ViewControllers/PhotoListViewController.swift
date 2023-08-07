//
//  PhotoListViewController.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import UIKit

final class PhotoListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkService.loadPhotos(page: 1, limit: 10, searchQuery: "tele") { result in
            switch result {
            case .success(let success):
                print(success.photos.photo.count)
                
//                if let photoUrl = success.photos.photo.first?.fullPath {
//                    DispatchQueue.global().async { [weak self] in
//                                if let data = try? Data(contentsOf: photoUrl) {
//                                    if let image = UIImage(data: data) {
//                                        DispatchQueue.main.async {
//                                            image.size
//                                        }
//                                    }
//                                }
//                            }
//                }
            case .failure(let failure):
                print(failure.message)
            }
        }
    }
    

}
