//
//  TheoryViewController+UITableViewDataSource.swift
//  FirstAid
//
//  Created by Anna Shanidze on 28.04.2022.
//

import UIKit

extension TheoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.CellIdentifiers.theoryCell, for: indexPath) as? TheoryTableViewCell
        
        guard let tableViewCell = cell else { return UITableViewCell() }
        let cellVM = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellVM
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeader
    }
    
}
