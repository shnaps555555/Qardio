//
//  PhotoListViewController.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import UIKit

final class PhotoListViewController: UIViewController {
    
    @IBOutlet private weak var searchView: PhotoListHeaderView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchViewHeightConstraint: NSLayoutConstraint!
    
    let viewModel = PhotoListViewModel()
    private var layout: DoubleRowStyleLayout? = nil
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        viewModel.willLoadHandler = { [weak self] in
            self?.activityIndicator.startAnimating()
        }
        viewModel.didLoadHandler = { [weak self] in
            guard let self else { return }
            
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
        viewModel.loadPhotos()
    }
    
    private func setupUI() {
        layout = collectionView?.collectionViewLayout as? DoubleRowStyleLayout
        layout?.delegate = self
        
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
        viewModel.searchQuery = query
        viewModel.loadPhotos()
        collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
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
            self?.layout?.clearCache()
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
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) && viewModel.isLoading == false {
            viewModel.loadPhotos()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchView.setSearchText(viewModel.searchQuery)
        searchView.endEditing(true)
    }
}

extension PhotoListViewController: DoubleRowStyleLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
            return min(viewModel.photos[indexPath.item].image.size.height / 2, 200) // max image height is 200; if we split original image height it will fit perfectly
        }
}
