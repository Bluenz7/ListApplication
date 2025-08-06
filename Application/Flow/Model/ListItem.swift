//
//  ListItem.swift
//  ListApplication
//
//  Created by Владислав Скриганюк on 25.07.2025.
//

import Foundation

// MARK: - DTO Model.

struct StocksDTO: Codable {
    let symbol: String?
    let name: String?
    let price: Double?
    let change: Double?
    let changePercent: Double?
    let logo: String?
}
