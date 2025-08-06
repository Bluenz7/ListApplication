//
//  CompanyNamesView.swift
//  ListApplication
//
//  Created by Владислав Скриганюк on 26.07.2025.
//

import Foundation
import UIKit

class CompanyFavoriteView: UIView {
    
    struct Model {
        let symbol: String?
        let state: FavoriteState
    }
    
    enum FavoriteState {
        case selected(UIColor)
        case diselected(UIColor)
    }
    
    // MARK: - Private Properties.
    
    private let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "FavSelected")
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Life Cycle.
    
    init() {
        super.init(frame: .zero)
        inizialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CompanyFavoriteView {
    func configured(by model: Model) {
        symbolLabel.text = model.symbol
        
        switch model.state {
        case .selected(let color):
            favoriteImageView.tintColor = color
        case .diselected(let color):
            favoriteImageView.tintColor = color
        }
    }
}

extension CompanyFavoriteView {
    private func inizialize() {
        setupSubViews()
        setConstraints()
    }
    
    private func setupSubViews() {
        addSubview(favoriteImageView)
        addSubview(symbolLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            symbolLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            symbolLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            favoriteImageView.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            favoriteImageView.leftAnchor.constraint(equalTo: symbolLabel.rightAnchor, constant: 6),
            favoriteImageView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: 0),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 16),
            favoriteImageView.heightAnchor.constraint(equalToConstant: 16),
            favoriteImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
        ])
    }
}
