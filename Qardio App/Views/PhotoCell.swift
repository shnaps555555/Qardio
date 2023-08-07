//
//  PhotoCell.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
  @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
    }
    
    var photo: Photo? {
        didSet {
            if let photo = photo {
                imageView.image = photo.image
                commentLabel.text = photo.title
            }
        }
    }
}
