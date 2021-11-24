//
//  ViewController.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 22.10.2021.
//

import UIKit
import DropDown

class TheoryViewController: UIViewController {
    
    // MARK: - Properties
    
    enum MenuState {
        case read, unread, all
    }
    
    var allLessons: [Lesson]?
    var filteredLessons: [Lesson]?
    
    var menuState: TheoryViewController.MenuState?
    
    let allDataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("AllTheory.plist")
    
    var jsonData = Data()
    
    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "lessonCell")
        return tableView
    }()
    
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["Показать только прочитанные",
                           "Показать только непрочитанные",
                           "Показать все"]
        return menu
    }()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(filterTapped))
        
        menu.anchorView = navigationItem.rightBarButtonItem
        
        if let data = DataHelper.shared.loadJson(filename: "theory") {
            jsonData = data
        }
        
        if !UserDefaults.standard.bool(forKey: "TheoryExecuteOnce") {
            allLessons = DataHelper.shared.createPlist(from: jsonData, at: allDataFilePath)
            UserDefaults.standard.set(true, forKey: "TheoryExecuteOnce")
        }
        
        loadLessons()
        
        dropDownMenuWork()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: - DropDown Menu Functionality
    
    @objc private func filterTapped() {
        menu.show()
    }
    
    func dropDownMenuWork() {
        menu.selectionAction = { [weak self] index, _ in
            
            self?.loadLessons()
            guard let allLessons = self?.allLessons else { return }
            
            switch index {
            case 0:
                self?.menuState = .read
                self?.filteredLessons = (allLessons.filter { $0.isFinished == true })
            case 1:
                self?.menuState = .unread
                self?.filteredLessons = (allLessons.filter { $0.isFinished == false })
            default:
                self?.menuState = .all
                self?.filteredLessons = allLessons.sorted { !$0.isFinished && $1.isFinished }
            }
            
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Load Lessons
    
    func loadLessons() {
        allLessons = DataHelper.shared.loadData(from: allDataFilePath)
        filteredLessons = allLessons?.sorted { !$0.isFinished && $1.isFinished }
    }
}

    // MARK: - Table view data source

extension TheoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLessons?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell", for: indexPath)
        
        cell.textLabel?.text = filteredLessons?[indexPath.row].title
        
        if let done = filteredLessons?[indexPath.row].isFinished {
            cell.backgroundColor = done ? UIColor(red: 0, green: 0.4, blue: 0, alpha: 0.5) : .systemBackground
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Первая помощь при ..."
    }
    
}

// MARK: - Table view delegate

extension TheoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = LessonViewController()
        
        vc.titleText = "Первая помощь при " + (filteredLessons?[indexPath.row].title)!.lowercased()
        vc.text = filteredLessons?[indexPath.row].text
        
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        
        present(navVC, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done])
    }
    
    func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        
        var lesson = filteredLessons![indexPath.row]
        let done = lesson.isFinished
        
        let action = UIContextualAction(style: .destructive, title: "Done") { [weak self] (action, view, completion) in
            
            self?.filteredLessons?[indexPath.row].isFinished = !done
            lesson.isFinished = !done
            
            // find selected item in all lessons
            if let itemID = self?.allLessons?.firstIndex(where: {$0.title == lesson.title}) {
                self?.allLessons?[itemID].isFinished = !done
                DataHelper.shared.saveData(self?.allLessons, at: self?.allDataFilePath)
            }
            
            let cell = self?.tableView.cellForRow(at: indexPath)
            
            switch self?.menuState {
            case .all, .none:
                if done {
                    cell?.backgroundColor = .systemBackground
                    self?.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0), with: lesson)
                } else {
                    cell?.backgroundColor = UIColor(red: 0, green: 0.4, blue: 0, alpha: 0.5)
                    let lastIndexPath = IndexPath(row: (self?.filteredLessons?.count)! - 1, section: 0)
                    self?.moveRow(at: indexPath, to: lastIndexPath, with: lesson)
                }
            case .read, .unread:
                self?.filteredLessons?.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            completion(true)
        }
        
        action.backgroundColor = done ? .systemRed : .systemGreen
        action.image = done ? UIImage(systemName: "xmark.circle") : UIImage(systemName: "checkmark.circle")
        
        return action
    }
    
    func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath, with lesson: Lesson) {
        tableView.moveRow(at: indexPath, to: newIndexPath)
        filteredLessons?.remove(at: indexPath.row)
        filteredLessons?.insert(lesson, at: newIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}


