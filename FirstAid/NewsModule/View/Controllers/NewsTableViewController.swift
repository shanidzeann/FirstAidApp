//
//  NewsTableViewController.swift
//  FirstAid
//
//  Created by Anna Shanidze on 02.02.2022.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let viewModel = NewsViewModel()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        registerCells()
        getArticles()
        
        tableView.rowHeight = Constants.TableView.RowHeights.news
    }
    
    // MARK: - Methods
    func getArticles() {
        viewModel.getArticles { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private func didPullToRefresh() {
        getArticles()
    }
    
    func registerCells() {
        var cellNib = UINib(nibName: Constants.TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: Constants.TableView.CellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(nibName: Constants.TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: Constants.TableView.CellIdentifiers.loadingCell)
    }
    
}
