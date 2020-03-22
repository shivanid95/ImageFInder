//
//  ImageFinderViewController.swift
//  ImageFinder
//
//  Created by Shivani on 21/03/20.
//  Copyright © 2020 demo. All rights reserved.
//

import UIKit


class ImageFinderViewController: UIViewController {
    
    private enum Constants {
        static let collectionViewCellReuseId = "searchCollectionViewCellId"
        static let searchbarPlaceholderText = "Find images by entering text"
    }
    
    var viewModel: ImageFinderViewModelProtocol!
    
// MARK: - UI Components
    
    fileprivate let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate lazy var imageSearchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.searchTextField.clearButtonMode = .always
        bar.placeholder = Constants.searchbarPlaceholderText
        bar.enablesReturnKeyAutomatically = false
        bar.returnKeyType = .search
        return bar
    }()
    
    fileprivate let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width / 2 - 24, height: 210)
        return layout
    }()
    
    fileprivate lazy var imageSearchCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        cv.backgroundColor = .clear
        cv.keyboardDismissMode = .onDrag
        cv.scrollsToTop = false
        cv.register(ImageFinderCollectionViewCell.self, forCellWithReuseIdentifier: Constants.collectionViewCellReuseId)
        cv.dataSource = self
        return cv
    }()
    
    fileprivate lazy var loadMoreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("Load More Images", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(didTapLoadMore(_:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate let emptyStateView: PlaceholderView = {
        let view = PlaceholderView()
        view.state = .emptySearch
        return view
    }()
    
// MARK:- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Image Finder"
        imageSearchCollectionView.isHidden = true
        
    }
    
// MARK: - Initialize
    
    init(viewModel: ImageFinderViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.viewModel.delegate = self
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Setup
    
    func setup() {
        
        view.addSubview(containerView)
        containerView.fillSuperviewSafeAreaLayoutGuide()
        containerView.stack(imageSearchBar,
                            imageSearchCollectionView,
                            emptyStateView,
                            loadMoreButton.withHeight(40),
                            spacing: 8,
                            alignment: .fill,
                            distribution: .fill)
            .withMargins(.init(top: 0, left: 8, bottom: 12, right: 8))
    }
    
// MARK: - Actions
    
    @objc func didTapLoadMore(_ sender: UIButton?) {
        viewModel.loadMoreImages()
    }
    
}
// MARK:- Image Finder View Delegate

extension ImageFinderViewController: ImageFinderViewDelegate {
    
    func searchResultsDidChange(emptyState: SearchPlaceholderState?) {
        
        DispatchQueue.main.async { [weak self] in
            self?.emptyStateView.isHidden = (emptyState == nil)
            self?.loadMoreButton.isHidden = !(emptyState == nil)
            self?.imageSearchCollectionView.isHidden = !(emptyState == nil)
            
            if let emptyState = emptyState {
                self?.emptyStateView.state = emptyState
            }
            else {
                self?.imageSearchCollectionView.reloadData()
            }
            
        }
    }
    
    
    func searchResultDidError() {
        
        DispatchQueue.main.async { [weak self] in
            self?.emptyStateView.isHidden = false
            self?.imageSearchCollectionView.isHidden = true
            self?.loadMoreButton.isHidden = true
            self?.emptyStateView.state = .error
        }
        
    }

}

//MARK: - Collection View Datatsource

extension ImageFinderViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCellReuseId, for: indexPath) as? ImageFinderCollectionViewCell else { fatalError("Cell Not Loaded") }
        let cellData = viewModel.imageData(at: indexPath.item)
        cell.title = cellData.title
        cell.urlString = cellData.imageUrl
        return cell
    }

}


//MARK: - Search bar delegate

extension ImageFinderViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.searchQuery = searchBar.text
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchQuery = searchBar.text
        searchBar.resignFirstResponder()
        
    }
    
    
}
