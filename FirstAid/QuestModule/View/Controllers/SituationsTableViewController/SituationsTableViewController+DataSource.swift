//
//  SituationsTableViewController+DataSource.swift
//  FirstAid
//
//  Created by Anna Shanidze on 28.04.2022.
//

import UIKit

extension SituationsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.CellIdentifiers.questCell, for: indexPath) as! SituationTableViewCell
        
        let cellVM = viewModel.cellViewModel(forIndexPath: indexPath)
        cell.SituationViewModel = cellVM
        
        return cell
    }
    
}
