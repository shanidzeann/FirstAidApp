//
//  NewsTableViewController.swift
//  FirstAid
//
//  Created by Anna Shanidze on 02.02.2022.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var viewModel: NewsViewModel!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewModel()
        configureTableView()
        registerCells()
        getArticles()
        addObserver()
    }
    
    // MARK: - Methods
    
    private func setViewModel() {
        let jsonParser = JSONParser()
        let networkManager = NetworkManager(jsonParser: jsonParser)
        viewModel = NewsViewModel(networkManager: networkManager)
    }
    
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
    
    private func configureTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.rowHeight = Constants.TableView.RowHeights.news
    }
    
    func registerCells() {
        var cellNib = UINib(nibName: Constants.TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: Constants.TableView.CellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(nibName: Constants.TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: Constants.TableView.CellIdentifiers.loadingCell)
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeSeparatorStyle), name: NSNotification.Name("lessonsStateChanged"), object: nil)
    }
    
    @objc private func changeSeparatorStyle() {
        switch viewModel.state {
        case .loading, .noResults:
            tableView.separatorStyle = .none
        case .results:
            tableView.separatorStyle = .singleLine
        }
    }
    
}
