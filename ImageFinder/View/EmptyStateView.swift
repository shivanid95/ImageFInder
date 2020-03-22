//
//  EmptyStateView.swift
//  ImageFinder
//
//  Created by Shivani on 21/03/20.
//  Copyright © 2020 demo. All rights reserved.
//

import UIKit

class PlaceholderView: UIView {
    
    
    var state: SearchPlaceholderState = .emptySearch {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.titleLabel.text = self?.state.message
            }
        }
    }
// MARK:- UI Components
    
    fileprivate let containerView: UIView = {
        let view = UIView()
        return view
    }()
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.image = #imageLiteral(resourceName: "Image")
        return iv
    }()
    
//MARK: - Initialize
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//MARK:- Setup
    
    func setup() {
        
        self.addSubview(containerView)
        containerView.centerInSuperview()
        containerView.stack(imageView.withSize(.init(width: 160,
                                                     height: 160)),
                            titleLabel,
                            spacing: 16,
                            alignment: .center,
                            distribution: .fill)
            .centerInSuperview()
    }
}
