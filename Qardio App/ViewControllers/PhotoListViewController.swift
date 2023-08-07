//
//  PhotoListViewController.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import UIKit

final class PhotoListViewController: UIViewController {
    
    @IBOutlet private weak var searchView: PhotoListHeaderView!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private weak var searchViewHeightConstraint: NSLayoutConstraint!
    
    let viewModel = PhotoListViewModel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.loadPhotos { [weak self] in
            guard let self else { return }
            self.collectionView.reloadData()
        }
    }
    
    private func setupUI() {
        if let layout = collectionView?.collectionViewLayout as? DoubleRowStyleLayout {
            layout.delegate = self
        }
        //      if let patternImage = UIImage(named: "Pattern") {
        //        view.backgroundColor = UIColor(patternImage: patternImage)
        //      }
        collectionView?.backgroundColor = .clear
        searchView.delegate = self
    }
    
}

extension PhotoListViewController: PhotoListHeaderViewDelegate {
    func historyViewDidChangeState(_ requestedHeight: CGFloat) {
        searchViewHeightConstraint.constant = requestedHeight
        searchView.setNeedsLayout()
    }
    
    func historyViewDidSearch(query: String) {
        
    }
    
}

extension PhotoListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath as IndexPath) as! PhotoCell
        let photo = viewModel.photos[indexPath.item]
        cell.photo = photo
        photo.loadImageIfNeeded { [weak self] in
            self?.collectionView.reloadData()
        }
        
        return cell
    }
}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            //            viewModel.photos.append(contentsOf: Photo.allPhotos())
            //            collectionView.reloadData()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchView.endEditing(true)
    }
}

extension PhotoListViewController: DoubleRowStyleLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
            return viewModel.photos[indexPath.item].image.size.height / 2
        }
}
