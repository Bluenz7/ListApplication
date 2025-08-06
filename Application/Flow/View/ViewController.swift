//
//  ViewController.swift
//  ListApplication
//
//  Created by Владислав Скриганюк on 25.07.2025.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Private Properties.
    
    private lazy var viewList = ViewList(didTapCellAt: { [weak self] selectedIndexPath in
        guard let self else { return }
        presenter.didTapItem(at: selectedIndexPath)
    })
    
    private lazy var presenter: StocksPresenterProtocol = {
        return StocksPresenter(view: self)
    }()
    
    // MARK: - Life Cycle.
    
    override func loadView() {
        view = viewList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        presenter.loadStock()
    }
    
    // MARK: - Private Methods.
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.shadowColor = nil
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find company or ticker"
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        // Настройка внешнего вида.
        let searchField = searchController.searchBar.searchTextField
        searchField.layer.cornerRadius = 18
        searchField.layer.masksToBounds = true
        searchField.layer.borderWidth = 2
        searchField.layer.borderColor = UIColor.black.cgColor
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
}

extension ViewController: StocksViewControllerProtocol {
    func setCollectionModel(param: CollectionModel) {
        viewList.setCollectionModel(param: param)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, searchController.isActive else { return }
        
        presenter.searchStocks(by: text)
    }
}

extension ViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        presenter.didTapSearchBar()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        presenter.didDismissSearchBar()
    }
    
    func searchController(_ searchController: UISearchController, willChangeTo newPlacement: UINavigationItem.SearchBarPlacement) {
        
    }
}
