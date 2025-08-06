//
//  TitleCollectionViewCell.swift
//  ListApplication
//
//  Created by Владислав Скриганюк on 31.07.2025.
//

import UIKit
import SnapKit

class TitleCollectionViewCell: UICollectionViewCell {
    
    struct Model {
        var title: String
    }
    
    // MARK: - Private properties.
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Life Cycle.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        inizialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods.
    
    private func inizialize() {
        setupSubViews()
        setConstraints()
        
        contentView.backgroundColor = UIColor(red: 245/255, green: 248/255, blue: 250/255, alpha: 1)
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
    }
    
    private func setupSubViews() {
        contentView.addSubview(titleLabel)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}

extension TitleCollectionViewCell: ConfigureCellProtocol {
    func configuredCell(by model: Any) {
        guard let model = model as? Model else { return }
        
        titleLabel.text = model.title
    }
}
