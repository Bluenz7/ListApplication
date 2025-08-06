//
//  StocksPresenter.swift
//  ListApplication
//
//  Created by Владислав Скриганюк on 25.07.2025.
//

import Foundation
import UIKit


protocol StocksViewControllerProtocol: AnyObject {
    func setCollectionModel(param: CollectionModel)
}

protocol StocksPresenterProtocol: AnyObject {
    func didTapItem(at indexPath: IndexPath)
    func loadStock()
    func didDismissSearchBar()
    func didTapSearchBar()
    func searchStocks(by text: String)
}

class StocksPresenter {
    
    weak var view: ViewController?
    
    private let service = StocksService()
    private var data: [StocksDTO] = []    
    private var presentaionState: PresentationStocksState = .all
    private var previousPresentationState: PresentationStocksState = .all
    private var collectionModel: CollectionModel = .init(section: [])
    
    init(view: ViewController) {
        self.view = view
    }
    // MARK: - Assembling Collection Model.
    
    private func buildModel(by data: [StocksDTO]) -> CollectionModel {
        
        var collectionModel: CollectionModel = CollectionModel(section: [])
        
        switch presentaionState {
        case .all, .favorite:
            var stocksSection = CollectionCellSection(
                items: [],
                headerType: SwitchStateHeaderView.self,
                headerModel: SwitchStateHeaderView.Model(
                    selectedState: presentaionState == .all ? .stocks : .favorite,
                    deselectColor: UIColor(hex: "#BABABA"),
                    selectedColor: UIColor.black,
                    selectedTextSize: UIFont(name: "Helvetica-Bold", size: CGFloat(28)),
                    deselectedTextSize: UIFont(name: "Helvetica-Bold", size: CGFloat(18)),
                    didSelectedState: { [weak self] state in
                        guard let self else { return }
                        switch state {
                        case .favorite:
                            self.previousPresentationState = .favorite
                            self.presentaionState = .favorite
                            print("Favorite tapped")
                        case .stocks:
                            self.previousPresentationState = .all
                            self.presentaionState = .all
                            print("Stoks tapped")
                        }
                        
                        self.view?.setCollectionModel(param: self.buildModel(by: self.data))
                    }
                ),
                type: .stocks
            )
            
            data.enumerated().forEach { index, stock in
                if presentaionState == .all {
                    stocksSection.items.append(createCollectionItem(from: stock, and: index))
                } else {
                    if let favoriteStokcs = UserDefaults.standard.stringArray(forKey: "favorite_stocks") {
                        if favoriteStokcs.contains(stock.name ?? "") {
                            stocksSection.items.append(createCollectionItem(from: stock, and: index))
                        }
                    }
                }
            }
            collectionModel.section.append(stocksSection)
            
            self.collectionModel = collectionModel
            
            return collectionModel
            
        case .search(let searchText):
            
            var section = CollectionCellSection(
                items: [],
                headerType: TitleHeaderView.self,
                headerModel: TitleHeaderView.Model(title: searchText.isEmpty ? "Popular requests" : "Stocks"),
                type: .search(text: searchText)
            )
            
            if searchText.isEmpty {
                let itemNames = ["Apple", "Amazon", "Google", "Tesla", "Microsoft", "First Solar", "Alibaba", "Facebook", "Mastercard"]
                
                for name in itemNames {
                    section.items.append(
                        CollectionCellItem(
                            cellType: TitleCollectionViewCell.self,
                            cellModel: TitleCollectionViewCell.Model(title: name)
                        )
                    )
                }
                
                var sectionTwo = CollectionCellSection(
                    items: [],
                    headerType: TitleHeaderView.self,
                    headerModel: TitleHeaderView.Model(title: searchText.isEmpty ? "You've searched for this" : ""),
                    type: .search(text: searchText)
                )
                
                let itemNamesNew = ["Nvidia", "Nokia", "Yandex", "GM", "Microsoft", "Baidu", "Intel", "AMD", "Visa", "Bank of America"]
                
                for name in itemNamesNew {
                    sectionTwo.items.append(
                        CollectionCellItem(
                            cellType: TitleCollectionViewCell.self,
                            cellModel: TitleCollectionViewCell.Model(title: name)
                        )
                    )
                }
                
                collectionModel.section.append(section)
                collectionModel.section.append(sectionTwo)
            } else {
                data.enumerated().forEach { index, stock in
                    if let symbol = stock.symbol, symbol.lowercased().hasPrefix(searchText.lowercased()) {
                        section.items.append(createCollectionItem(from: stock, and: index))
                    } else if let name = stock.name, name.lowercased().hasPrefix(searchText.lowercased()) {
                        section.items.append(createCollectionItem(from: stock, and: index))
                    }
                }
                
                collectionModel.section.append(section)
            }
            
            self.collectionModel = collectionModel
            
            return collectionModel
        }
    }
    
    private func createCollectionItem(from stock: StocksDTO, and index: Int) -> CollectionCellItem {
        var color: UIColor = UIColor(hex: "#F0F4F7") ?? .white
        if index % 2 == 0 {
            color = .white
        }
        
        var colorStock: UIColor = UIColor(hex: "#B22424") ?? .clear
        
        if (stock.change ?? .zero) >= 0.00 {
            colorStock = UIColor(hex: "#24B25D") ?? .clear
        }
        
        var selectState: CompanyFavoriteView.FavoriteState = .diselected(UIColor(hex: "#BABABA") ?? .lightGray)
        
        if let favoriteStokcs = UserDefaults.standard.stringArray(forKey: "favorite_stocks") {
            if favoriteStokcs.contains(stock.name ?? "") {
                selectState = .selected(UIColor(hex: "#FFCA1C") ?? .yellow)
            }
        }
        
        return CollectionCellItem(
            cellType: StocksCollectionViewCell.self,
            cellModel: StocksCollectionViewCell.Model(
                logo: URL(string: "\(stock.logo ?? "")"),
                price: "$\(stock.price ?? .zero)",
                correlation: changeString(by: stock),
                name: stock.name,
                company: CompanyFavoriteView.Model(
                    symbol: stock.symbol,
                    state: selectState
                ),
                backgroundColor: color,
                textColor: colorStock
            )
        )
    }
    
    func changeString(by data: StocksDTO) -> String {
        var arrayChars  = ("\(data.change ?? 0)" + " " + "(\(data.changePercent ?? 0)%)").split(separator: "")
        if arrayChars.first == "-" {
            arrayChars.insert("$", at: 1)
        } else {
            arrayChars.insert("+", at: 0)
            arrayChars.insert("$", at: 1)
        }
        return arrayChars.joined()
    }
}

extension StocksPresenter: StocksPresenterProtocol {
    func didTapItem(at indexPath: IndexPath) {
        switch presentaionState {
        case .all, .favorite:
            guard let stockModel = collectionModel.section[indexPath.section].items[indexPath.item].cellModel as? StocksCollectionViewCell.Model,
                  let name = stockModel.name else { return }
            
            if var favoriteArray = UserDefaults.standard.stringArray(forKey: "favorite_stocks") {
                if let index = favoriteArray.firstIndex(where: { localName in
                    localName == name
                }) {
                    favoriteArray.remove(at: index)
                    UserDefaults.standard.set(favoriteArray, forKey: "favorite_stocks")
                } else {
                    favoriteArray.append(name)
                    UserDefaults.standard.set(favoriteArray, forKey: "favorite_stocks")
                }
            } else {
                UserDefaults.standard.set([name], forKey: "favorite_stocks")
            }
            
            view?.setCollectionModel(param: buildModel(by: data))
        case .search:
            break
        }
    }
    
    func searchStocks(by text: String) {
        presentaionState = .search(text: text)
        view?.setCollectionModel(param: buildModel(by: data))
    }
    
    func didTapSearchBar() {
        presentaionState = .search()
        view?.setCollectionModel(param: buildModel(by: data))
    }
    
    func didDismissSearchBar() {
        presentaionState = previousPresentationState
        view?.setCollectionModel(param: buildModel(by: data))
    }
    
    // MARK: - Load Data
    
    func loadStock() {
        service.fetchStocks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let stocks):
                    guard let self else { return }
                    print(self)
                    print("✅ Stock loaded:", stocks)
                    self.data = stocks
                    
                    self.view?.setCollectionModel(param: self.buildModel(by: self.data))
                    
                case .failure(let error):
                    print("Не удалось загрузить акции: \(error.localizedDescription)")
                }
            }
        }
    }
}
