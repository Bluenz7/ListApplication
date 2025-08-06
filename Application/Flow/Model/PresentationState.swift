//
//  PresentationState.swift
//  ListApplication
//
//  Created by Владислав Скриганюк on 31.07.2025.
//

import Foundation

enum PresentationStocksState: Equatable {
    case all
    case favorite
    case search(text: String = "")
}
