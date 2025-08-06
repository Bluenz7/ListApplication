//
//  StockCollectionViewCell.swift
//  ListApplication
//
//  Created by Владислав Скриганюк on 25.07.2025.
//
import Kingfisher
import UIKit

class StocksCollectionViewCell: UICollectionViewCell {
    
    struct Model {
        let logo: URL?
        let price: String?
        let correlation: String
        let name: String?
        let company: CompanyFavoriteView.Model
        let backgroundColor: UIColor
        let textColor: UIColor
    }
    
    // MARK: - Private Properties.
    
    private let companyViews = CompanyFavoriteView()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        return image
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right 
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let correlationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.addArrangedSubview(companyViews)
        stack.addArrangedSubview(nameLabel)
        return stack
    }()
    
    private lazy var stackViewTwo: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.addArrangedSubview(priceLabel)
        stack.addArrangedSubview(correlationLabel)
        return stack
    }()
    
    // MARK: - Life Cycle.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        inizialize()
        setupViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods.
    
    private func setupViewCell() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}


extension StocksCollectionViewCell: ConfigureCellProtocol {
    func configuredCell(by model: Any) {
        guard let model = model as? Model else { return }
        
        logoImage.kf.setImage(with: model.logo)
        priceLabel.text = model.price ?? ""
        correlationLabel.text = model.correlation
        correlationLabel.textColor = model.textColor
        nameLabel.text = model.name
        companyViews.configured(by: model.company)
        backgroundColor = model.backgroundColor
    }
}

extension StocksCollectionViewCell {
   private func inizialize() {
        setupSubViews()
        setConstraints()
    }
    
   private func setupSubViews() {
       addSubview(containerView)
       containerView.addSubview(logoImage)
       containerView.addSubview(priceLabel)
       containerView.addSubview(correlationLabel)
       containerView.addSubview(stackView)
       containerView.addSubview(stackViewTwo)
    }
    
   private func setConstraints() {
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            
            logoImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            logoImage.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            logoImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            logoImage.widthAnchor.constraint(equalToConstant: 52),
            logoImage.heightAnchor.constraint(equalToConstant: 52),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            stackView.leftAnchor.constraint(equalTo: logoImage.rightAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14),
            
            stackViewTwo.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            stackViewTwo.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -17),
            stackViewTwo.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14),
        ])
    }
}
