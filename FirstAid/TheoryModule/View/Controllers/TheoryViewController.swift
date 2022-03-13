//
//  ViewController.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 22.10.2021.
//

import UIKit

class TheoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = TheoryViewModel()
    
    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TheoryTableViewCell.self, forCellReuseIdentifier: Identifiers.tableViewCell.rawValue)
        return tableView
    }()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        addTableView()
        configureNavigationBar()
        setData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: - DropDown Menu Functionality
    
    func menuWork(index: Int) {
        viewModel.filterLessons(at: index)
        tableView.reloadData()
    }
    
    // MARK: - Helper Methods
    
    func setBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    func addTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setData() {
        viewModel.createLessons()
        viewModel.loadLessons()
    }
    
    func configureNavigationBar() {
        let showRead = UIAction(title: "Показать прочитанные") { [weak self] (action) in
            self?.menuWork(index: 0)
        }
        
        let showUnread = UIAction(title: "Показать непрочитанные") { [weak self] (action) in
            self?.menuWork(index: 1)
        }
        
        let showAll = UIAction(title: "Показать все") { [weak self] (action) in
            self?.menuWork(index: 2)
        }
        
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: .singleSelection, children: [showRead, showUnread, showAll])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis"), primaryAction: nil, menu: menu)
    }
}

    // MARK: - Table view data source

extension TheoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.tableViewCell.rawValue, for: indexPath) as? TheoryTableViewCell
        
        guard let tableViewCell = cell else { return UITableViewCell() }
        let cellVM = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellVM
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeader
    }
    
}

// MARK: - Table view delegate

extension TheoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = LessonViewController()
        
        guard let selectedLesson = viewModel.selectedLesson(at: indexPath),
              let lessonVM = viewModel.lessonViewModel(for: selectedLesson) else { return }
        vc.viewModel = lessonVM
        
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
        
        guard var lesson = viewModel.selectedLesson(at: indexPath) else { return UIContextualAction() }
        
        let action = UIContextualAction(style: .destructive, title: "Done") { [weak self] (action, view, completion) in
            
            guard let self = self else { return }
            let viewModel = self.viewModel
            
            viewModel.toggleCompletion(of: &lesson, at: indexPath)
            
            guard let cell = self.tableView.cellForRow(at: indexPath) as? TheoryTableViewCell else { return }
            cell.done = lesson.isFinished
            
            switch viewModel.menuState {
            case .all, .none:
                cell.setBackground()
                if !cell.done {
                    self.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0), with: lesson)
                } else {
                    let lastIndexPath = IndexPath(row: (viewModel.filteredLessons?.count)! - 1, section: 0)
                    self.moveRow(at: indexPath, to: lastIndexPath, with: lesson)
                }
            case .read, .unread:
                viewModel.removeLesson(at: indexPath)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            completion(true)
        }
        
        action.backgroundColor = lesson.isFinished ? .systemRed : .systemGreen
        action.image = lesson.isFinished ? UIImage(systemName: "xmark.circle") : UIImage(systemName: "checkmark.circle")
        
        return action
    }
    
    func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath, with lesson: Lesson) {
        tableView.moveRow(at: indexPath, to: newIndexPath)
        viewModel.removeLesson(at: indexPath)
        viewModel.insert(lesson, at: newIndexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
