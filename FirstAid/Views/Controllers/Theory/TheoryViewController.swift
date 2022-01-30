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
    
    private var viewModel: TheoryViewModelType! {
        didSet {
            viewModel?.createLessons()
            viewModel?.loadLessons()
        }
    }
    
    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TheoryTableViewCell.self, forCellReuseIdentifier: "cell")
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
        
        setBackgroundColor()
        addTableView()
        configureNavigationBar()
        setViewModel()
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
        menu.anchorView = navigationItem.rightBarButtonItem
        
        menu.selectionAction = { [weak self] index, _ in
            guard let viewModel = self?.viewModel else { return }
            
            viewModel.filterLessons(at: index)
            self?.tableView.reloadData()
        }
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
    
    func setViewModel() {
        viewModel = TheoryViewModel()
    }
    
    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(filterTapped))
    }
}

    // MARK: - Table view data source

extension TheoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TheoryTableViewCell
        
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        let cellVM = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.TheoryViewModel = cellVM
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Первая помощь при ..."
    }
    
}

// MARK: - Table view delegate

extension TheoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = LessonViewController()
        
        let selectedLesson = viewModel.selectedLesson(at: indexPath)
        let lessonVM = viewModel.lessonViewModel(for: selectedLesson)
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
        
        var lesson = viewModel.selectedLesson(at: indexPath)
        
        let action = UIContextualAction(style: .destructive, title: "Done") { [weak self] (action, view, completion) in
            
            guard let self = self,
                  let viewModel = self.viewModel else { return }
            
            viewModel.toggleCompletion(of: &lesson, at: indexPath)
            
            let cell = self.tableView.cellForRow(at: indexPath) as! TheoryTableViewCell
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