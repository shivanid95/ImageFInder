//
//  ImageFinderCollectionViewCell.swift
//  ImageFinder
//
//  Created by Shivani on 21/03/20.
//  Copyright © 2020 demo. All rights reserved.
//

import UIKit


class ImageFinderCollectionViewCell: UICollectionViewCell{
    
    var urlString: String? {
        didSet {
            guard let urlString = urlString, let url = URL(string: urlString) else { return }
            self.searchImageView.image = nil
            searchImageView.loadImage(url: url)
        }
    }
    
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
      //MARK: - UI Components
    
    fileprivate let containerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.systemGray6.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    fileprivate let searchImageView: LoadableImageView = {
        let imgView = LoadableImageView()
        imgView.backgroundColor = .lightGray
        return imgView
    }()
    
    fileprivate let titleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK:- Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    
    func setup() {
        
        addSubview(containerView)
        containerView.fillSuperview()
        containerView.stack(searchImageView.withHeight(128),
                            titleLabel,
                            spacing: 16,
                            alignment: .fill,
                            distribution: .fill).withMargins(
                                .init(top: 16,
                                      left: 16,
                                      bottom: 16,
                                      right: 16))
        
        titleLabel.widthAnchor.constraint(equalTo: searchImageView.widthAnchor,
                                          multiplier: 1).isActive = true
    }
    
}

