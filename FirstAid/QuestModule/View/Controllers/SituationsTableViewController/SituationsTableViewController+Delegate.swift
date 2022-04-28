//
//  SituationsTableViewController+Delegate.swift
//  FirstAid
//
//  Created by Anna Shanidze on 28.04.2022.
//

import UIKit

extension SituationsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let situation = viewModel.selectedSituation(at: indexPath) else { return }
        
        if situation.isFinished {
            let alert = UIAlertController(title: "Начать заново?", message: nil, preferredStyle: .actionSheet)
            var action = UIAlertAction(title: "Отменить", style: .cancel) { _ in
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
            alert.addAction(action)
            
            action = UIAlertAction(title: "Да", style: .destructive) { [weak self] _ in
                self?.performSegue(withIdentifier: Constants.SegueIdentifiers.sceneSegue, sender: self)
                self?.viewModel.saveEnding(situation: situation, isFinished: false, isSuccess: false)
            }
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: Constants.SegueIdentifiers.sceneSegue, sender: self)
        }
    }
    
}
