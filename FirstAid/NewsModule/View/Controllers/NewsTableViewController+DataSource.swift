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
            return createLoadingCell(for: indexPath)
        case .noResults:
            return createNothingFoundCell(for: indexPath)
        case .results:
            return createResultCell(for: indexPath)
        }
    }
    
    private func createLoadingCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.CellIdentifiers.loadingCell, for: indexPath)
        let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
        spinner.startAnimating()
        return cell
    }
    
    private func createNothingFoundCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        return cell
    }
    
    private func createResultCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.CellIdentifiers.resultCell, for: indexPath) as? NewsTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.viewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        return cell
    }
    
}
