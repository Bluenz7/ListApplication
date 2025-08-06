//
//  TitleHeaderVIew.swift
//  ListApplication
//
//  Created by Владислав Скриганюк on 31.07.2025.
//

import UIKit

final class TitleHeaderView: UICollectionReusableView {
    
    // MARK: - Model.
    
    struct Model {
        var title: String
        
        init(title: String) {
            self.title = title
        }
    }
    
    // MARK: - Private Properties.
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black 
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Life Cycle.
    
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
    }
}

extension TitleHeaderView: ConfigurableHeader {
    func configure(by model: Any) {
        guard let model = model as? Model else { return }
        titleLabel.text = model.title
    }
}

extension TitleHeaderView {
    private func inizialize() {
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.bottom.equalToSuperview().inset(11)
            make.left.equalToSuperview().offset(4)
        }
    }
    
}
