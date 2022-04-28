//
//  SituationsTableViewController.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 25.10.2021.
//

import UIKit

class SituationsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private(set) var viewModel = SituationsViewModel()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSituations()
        tableView.rowHeight = Constants.TableView.RowHeights.quest
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - Hepler Methods
    
    private func loadSituations() {
        viewModel.loadSituations()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == Constants.SegueIdentifiers.sceneSegue else { return }
        
        if let indexPath = tableView.indexPathForSelectedRow,
           let selectedSituation = viewModel.selectedSituation(at: indexPath) {
            let vc = segue.destination as! SceneViewController
            vc.viewModel = viewModel.situationViewModel(for: selectedSituation)
        }
    }
    
}
