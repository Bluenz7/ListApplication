//
//  HeaderSupplementaryView.swift
//  ListApplication
//
//  Created by Владислав Скриганюк on 27.07.2025.
//

import Foundation
import UIKit

final class SwitchStateHeaderView: UICollectionReusableView {
    
    // MARK: - Model.
    
    struct Model {
        var selectedState: SearchState
        var deselectColor: UIColor?
        var selectedColor: UIColor?
        var selectedTextSize: UIFont?
        var deselectedTextSize: UIFont?
        
        var didSelectedState: ((SearchState) -> Void)?
        
        init(
            selectedState: SearchState,
            deselectColor: UIColor?,
            selectedColor: UIColor?,
            selectedTextSize: UIFont?,
            deselectedTextSize: UIFont?,
            didSelectedState: ((SearchState) -> Void)?
        ) {
            self.selectedState = selectedState
            self.deselectColor = deselectColor
            self.selectedColor = selectedColor
            self.selectedTextSize = selectedTextSize
            self.deselectedTextSize = deselectedTextSize
            self.didSelectedState = didSelectedState
        }
    }
    
    enum SearchState {
        case stocks
        case favorite
    }
    
    // MARK: - Private Properties.
    
    private lazy var stocksButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Stocks", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        button.addTarget(self, action: #selector(stocksButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Favorite", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var model: Model?
    
    // MARK: - life Cycle.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        inizialize()
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.02
        layer.masksToBounds = false
    }
    
    @objc func stocksButtonTapped() {
        model?.didSelectedState?(.stocks)
    }
    @objc func favoriteButtonTapped() {
        model?.didSelectedState?(.favorite)
    }
}

extension SwitchStateHeaderView: ConfigurableHeader {
    func configure(by model: Any) {
        guard let model = model as? Model else { return }
        self.model = model
        switch model.selectedState {
        case .stocks:
            stocksButton.setTitleColor(model.selectedColor, for: .normal)
            favoriteButton.setTitleColor(model.deselectColor, for: .normal)
            stocksButton.titleLabel?.font = model.selectedTextSize
            favoriteButton.titleLabel?.font = model.deselectedTextSize
        case .favorite:
            stocksButton.setTitleColor(model.deselectColor, for: .normal)
            favoriteButton.setTitleColor(model.selectedColor, for: .normal)
            stocksButton.titleLabel?.font = model.deselectedTextSize 
            favoriteButton.titleLabel?.font = model.selectedTextSize
        }
    }
}

extension SwitchStateHeaderView {
    private func inizialize() {
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        addSubview(stocksButton)
        addSubview(favoriteButton)
    }
    
    private func setConstraints() {
        stocksButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.left.equalTo(stocksButton.snp.right).offset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
}
