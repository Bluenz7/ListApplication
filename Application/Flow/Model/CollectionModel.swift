//
//  CollectionCellItem.swift
//  ListApplication
//
//  Created by Владислав Скриганюк on 25.07.2025.
//

import Foundation
import UIKit

// MARK: - CollectionModel.

struct CollectionModel {
    var section: [CollectionCellSection]
}

struct CollectionCellSection {
    var items: [CollectionCellItem]
    var headerType: UICollectionReusableView.Type
    var headerModel: Any?
    var headerId: String {
        String(describing: headerType.self)
    }
    var type: SectionType
}

enum SectionType {
    case stocks
    case search(text: String)
}

struct CollectionCellItem {
    var cellType: UICollectionViewCell.Type
    var cellModel: Any
    var id: String {
        String(describing: cellType.self)
    }
}

