//
//  SituationsTableViewController.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 25.10.2021.
//

import UIKit

class SituationsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    struct TableView {
        struct CellIdentifiers {
            static let questCell = "questCell"
        }
    }
    
    struct SegueIdentifiers {
        static let sceneSegue = "sceneSegue"
    }
    
    private var viewModel = SituationsViewModel()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSituations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - Hepler Methods
    
    func loadSituations() {
        viewModel.loadSituations()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == SegueIdentifiers.sceneSegue else { return }
        
        if let indexPath = tableView.indexPathForSelectedRow,
           let selectedSituation = viewModel.selectedSituation(at: indexPath) {
            let vc = segue.destination as! SceneViewController
            vc.viewModel = viewModel.situationViewModel(for: selectedSituation, delegate: viewModel)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.questCell, for: indexPath) as! SituationTableViewCell
        
        let cellVM = viewModel.cellViewModel(forIndexPath: indexPath)
        cell.SituationViewModel = cellVM
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let situation = viewModel.selectedSituation(at: indexPath) else { return }
        
        if situation.isFinished {
            let alert = UIAlertController(title: "Начать заново?", message: nil, preferredStyle: .actionSheet)
            var action = UIAlertAction(title: "Отменить", style: .cancel) { _ in
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
            alert.addAction(action)
            
            action = UIAlertAction(title: "Да", style: .destructive) { [weak self] _ in
                self?.performSegue(withIdentifier: SegueIdentifiers.sceneSegue, sender: self)
                self?.viewModel.endReceived(situation: situation, isFinished: false, isSuccess: false)
                }
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: SegueIdentifiers.sceneSegue, sender: self)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
