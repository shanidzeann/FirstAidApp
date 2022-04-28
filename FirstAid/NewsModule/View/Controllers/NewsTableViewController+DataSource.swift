//
//  NewsTableViewController+DataSource.swift
//  FirstAid
//
//  Created by Anna Shanidze on 28.04.2022.
//

import UIKit

extension NewsTableViewController {
    
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
    
}
