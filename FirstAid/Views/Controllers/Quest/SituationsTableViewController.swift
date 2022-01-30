//
//  SituationsTableViewController.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 25.10.2021.
//

import UIKit

class SituationsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    #warning("подумать про optionals")
    private var viewModel: SituationsViewModel! {
        didSet {
            viewModel?.loadSituations()
            print("ситуации есть")
        }
    }
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        setViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - Hepler Methods
    
    func setViewModel() {
        viewModel = SituationsViewModel()
        print("вьюмодел есть")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "sceneSegue" else { return }
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let vc = segue.destination as! SceneViewController
            let selectedSituation = viewModel.selectedSituation(at: indexPath)
            vc.viewModel = viewModel.viewModelForSelectedRow(for: selectedSituation)
            vc.viewModel?.id = indexPath.row // это потом убрать
            vc.delegate = self // и это может тоже
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questCell", for: indexPath) as! SituationTableViewCell
        
        let cellVM = viewModel.cellViewModel(forIndexPath: indexPath)
        cell.SituationViewModel = cellVM
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let done = viewModel.selectedSituation(at: indexPath).isFinished
        
        if done {
            let alert = UIAlertController(title: "Начать заново?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(
                title: "Отменить",
                style: .cancel) { _ in
                    tableView.deselectRow(at: indexPath, animated: true)
                })
            alert.addAction(UIAlertAction(
                title: "Да",
                style: .destructive) { [weak self] _ in
                    self?.performSegue(withIdentifier: "sceneSegue", sender: self)
                    self?.endReceived(id: indexPath.row, isFinished: false, isSuccess: false)
                })
            present(alert, animated: true, completion: nil)
            
        } else {
            performSegue(withIdentifier: "sceneSegue", sender: self)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
 

}

// MARK: - Receive data about quest completion from SceneVC

extension SituationsTableViewController: CanReceive {
    // TODO: - и тут подумать
    func endReceived(id: Int, isFinished: Bool, isSuccess: Bool) {
      //  viewModel.saveEnding(id: id, isFinished: isFinished, isSuccess: isSuccess)
//        situationsPlist?[id].isFinished = isFinished
//        situationsPlist?[id].isSuccess = isSuccess
//        DataHelper.shared.saveData(situationsPlist, at: dataFilePath)
    }
}
