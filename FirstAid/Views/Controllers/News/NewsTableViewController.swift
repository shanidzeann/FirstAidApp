//
//  NewsTableViewController.swift
//  FirstAid
//
//  Created by Anna Shanidze on 02.02.2022.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    struct TableView {
        struct CellIdentifiers {
            static let resultCell = "ResultCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }
    
    struct SegueIdentifiers {
        static let articleSegue = "articleSegue"
    }
    
    let viewModel = NewsViewModel()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        getArticles()
    }
    
    // MARK: - Methods
    func getArticles() {
        viewModel.getArticles { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func registerCells() {
        var cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.state {
        case .loading:
            tableView.separatorStyle = .none
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            cell.backgroundColor = .secondarySystemBackground
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
            
        case .noResults:
            tableView.separatorStyle = .none
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
            cell.backgroundColor = .secondarySystemBackground
            return cell
            
        case .results:
            tableView.separatorStyle = .singleLine
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.resultCell, for: indexPath) as? NewsTableViewCell
            guard let cell = cell else { return UITableViewCell() }
            cell.viewModel = viewModel.cellViewModel(forIndexPath: indexPath)
            return cell
        }
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifiers.articleSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == SegueIdentifiers.articleSegue else { return }
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let vc = segue.destination as? ArticleViewController
            guard let article = viewModel.selectedArticle(atIndexPath: indexPath) else { return }
            vc?.viewModel = viewModel.articleViewModel(for: article)
        }
    }
    
}
