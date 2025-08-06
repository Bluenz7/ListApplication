//
//  ViewList.swift
//  ListApplication
//
//  Created by Владислав Скриганюк on 25.07.2025.
//

import Foundation
import SnapKit

class ViewList: UIView {
    
    // MARK: Private Properties.
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.register(SwitchStateHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: SwitchStateHeaderView.self))
        collectionView.register(TitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: TitleHeaderView.self))
        
        collectionView.register(StocksCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: StocksCollectionViewCell.self))
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: TitleCollectionViewCell.self))
        return collectionView
    }()
    
    var didTapCellAt: ((IndexPath) -> Void)
    
    private enum Constraints {
        static let left: CGFloat = 16
        static let right: CGFloat = 16
    }
    
    private var collectionModel: CollectionModel = CollectionModel(section: [])
    
    // MARK: Life Cycle.
    
    init(didTapCellAt: @escaping ((IndexPath) -> Void)) {
        self.didTapCellAt = didTapCellAt
        super.init(frame: .zero)
        inizialize()
        setDelegates()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods.
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            
            let type = collectionModel.section[sectionIndex].type
            
            switch type {
            case .search(let text):
                if text.isEmpty {
                    let item = NSCollectionLayoutItem(
                        layoutSize: .init(
                            widthDimension: .estimated(100),
                            heightDimension: .estimated(60)
                        )
                    )
                    
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .estimated(60)
                        ),
                        subitems: [item]
                    )
                    group.interItemSpacing = .fixed(4)
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.interGroupSpacing = 10
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
                    section.boundarySupplementaryItems = [supplementaryHeaderItem(contentInsets: .zero)]
                    return section
                } else {
                    return createStocksSectionLayout(contentInsetsForHeader: .init(top: 0, leading: 20, bottom: 0, trailing: 0))
                }
            case .stocks:
                return createStocksSectionLayout(contentInsetsForHeader: .zero)
            }
        }
    }
    
    private func createStocksSectionLayout(contentInsetsForHeader: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(68)))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(68)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.boundarySupplementaryItems = [supplementaryHeaderItem(contentInsets: contentInsetsForHeader)]
        section.contentInsets = .init(top: 0, leading: 0, bottom: 25, trailing: 0)
        return section
    }
    
    private func supplementaryHeaderItem(contentInsets: NSDirectionalEdgeInsets) -> NSCollectionLayoutBoundarySupplementaryItem {
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.pinToVisibleBounds = true
        header.contentInsets = contentInsets
        return header
    }
}

// MARK: - Setup Model.

extension ViewList: StocksViewControllerProtocol {
    func setCollectionModel(param: CollectionModel) {
        collectionModel = param
        collectionView.reloadData()
    }
}

// MARK: - Setup Collection Cells.

extension ViewList: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionModel.section.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionModel.section[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapCellAt(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionModel.section[indexPath.section].items[indexPath.item].id, for: indexPath)
        
        guard let configureCell = cell as? ConfigureCellProtocol else {
            return cell
        }
        
        configureCell.configuredCell(by: collectionModel.section[indexPath.section].items[indexPath.item].cellModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: collectionModel.section[indexPath.section].headerId,
                for: indexPath
            )
            
            if let header = header as? ConfigurableHeader {
                header.configure(by: collectionModel.section[indexPath.section].headerModel)
            }
            
            return header
        }
        return UICollectionReusableView()
    }
}

// MARK: - Setup Constraints.

extension ViewList {
    private func inizialize() {
        setupView()
        setConstraints()
    }
    
    private func setupView() {
        addSubview(collectionView)
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.top.equalToSuperview().offset(190)
        }
    }
}
