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
        
        tableView.rowHeight = 130
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
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.state {
        case .loading:
            tableView.separatorStyle = .none
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.CellIdentifiers.loadingCell, for: indexPath)
            cell.backgroundColor = .systemBackground
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
            
        case .noResults:
            tableView.separatorStyle = .none
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
            cell.backgroundColor = .systemBackground
            return cell
            
        case .results:
            tableView.separatorStyle = .singleLine
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.CellIdentifiers.resultCell, for: indexPath) as? NewsTableViewCell
            guard let cell = cell else { return UITableViewCell() }
            cell.viewModel = viewModel.cellViewModel(forIndexPath: indexPath)
            return cell
        }
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.SegueIdentifiers.articleSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.SegueIdentifiers.articleSegue else { return }
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let vc = segue.destination as? ArticleViewController
            guard let article = viewModel.selectedArticle(atIndexPath: indexPath) else { return }
            vc?.viewModel = viewModel.articleViewModel(for: article)
        }
    }
    
}
