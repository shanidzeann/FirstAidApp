//
//  SituationsTableViewController.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 25.10.2021.
//

import UIKit

protocol CanReceive {
    func endReceived(id: Int, isFinished: Bool, isSuccess: Bool)
}

class SituationsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var jsonData = Data()
    var situation: Situations?
    var situationPlist: [SituationPlist]?
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Quests.plist")
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = DataHelper.shared.loadJson(filename: "graph") {
            jsonData = data
        }
        
        situation = try? JSONDecoder().decode(Situations.self, from: jsonData)
        
        if !UserDefaults.standard.bool(forKey: "QuestExecuteOnce") {
            situationPlist = DataHelper.shared.createPlist(from: jsonData, at: dataFilePath)
            UserDefaults.standard.set(true, forKey: "QuestExecuteOnce")
        } else {
            situationPlist = DataHelper.shared.loadData(from: dataFilePath)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return situation?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "situationCell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = situation?[indexPath.row].title
        
        if let done = situationPlist?[indexPath.row].isFinished,
           let success = situationPlist?[indexPath.row].isSuccess {
            
            let successImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            successImageView.image = UIImage(systemName: "face.smiling.fill")
            successImageView.tintColor = UIColor(red: 0, green: 0.4, blue: 0, alpha: 0.5)
            
            let failImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            failImageView.image = UIImage(systemName: "hand.thumbsdown.fill")
            failImageView.tintColor = .systemRed
            
            if done && success {
                cell.accessoryView = successImageView
            } else if done && !success {
                cell.accessoryView = failImageView
            } else {
                cell.accessoryView = .none
            }
        }
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let done = situationPlist?[indexPath.row].isFinished else {
            return
        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "sceneSegue" else { return }
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let vc = segue.destination as! SceneViewController
            vc.situation = situation?[indexPath.row]
            vc.id = indexPath.row
            vc.delegate = self
        }
    }
}

// MARK: - Receive data about quest completion from SceneVC

extension SituationsTableViewController: CanReceive {
    func endReceived(id: Int, isFinished: Bool, isSuccess: Bool) {
        situationPlist?[id].isFinished = isFinished
        situationPlist?[id].isSuccess = isSuccess
        DataHelper.shared.saveData(situationPlist, at: dataFilePath)
    }
}
