//
//  NewsTableViewController+Delegate.swift
//  FirstAid
//
//  Created by Anna Shanidze on 28.04.2022.
//

import UIKit

extension NewsTableViewController {
    
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
