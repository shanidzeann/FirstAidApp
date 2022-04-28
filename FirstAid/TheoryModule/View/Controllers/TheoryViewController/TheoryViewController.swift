//
//  ViewController.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 22.10.2021.
//

import UIKit

class TheoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private(set) var viewModel = TheoryViewModel()
    
    // MARK: - UI
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TheoryTableViewCell.self, forCellReuseIdentifier: Constants.TableView.CellIdentifiers.theoryCell)
        tableView.rowHeight = 80
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
    
    private func showFilteredLessons(by state: LessonsState) {
        viewModel.filterLessons(by: state)
        tableView.reloadData()
    }
    
    // MARK: - Private
    
    private func setBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    private func addTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setData() {
        viewModel.createLessons()
        viewModel.loadLessons()
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil,
                                                            image: UIImage(systemName: "ellipsis"),
                                                            primaryAction: nil,
                                                            menu: createMenu())
    }
    
    private func createMenu() -> UIMenu {
        var actions = [UIAction]()
        
        for state in LessonsState.allCases {
            let action = UIAction(title: state.title) { [weak self] _ in
                self?.showFilteredLessons(by: state)
            }
            actions.append(action)
        }
        
        return UIMenu(title: "", options: .singleSelection, children: actions)
    }
    
    // MARK: - Helper methods for delegate
    
    func presentLesson(for indexPath: IndexPath) {
        guard let vc = createLessonVC(for: indexPath) else { return }
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
    func createLessonVC(for indexPath: IndexPath) -> LessonViewController? {
        guard let selectedLesson = viewModel.selectedLesson(at: indexPath),
              let lessonVM = viewModel.lessonViewModel(for: selectedLesson) else { return nil }
        let vc = LessonViewController()
        vc.viewModel = lessonVM
        return vc
    }
    
    func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        
        guard var lesson = viewModel.selectedLesson(at: indexPath) else { return UIContextualAction() }
        
        let action = UIContextualAction(style: .destructive, title: "Done") { [weak self] (action, _, completion) in
            
            guard let self = self,
                  let cell = self.tableView.cellForRow(at: indexPath) as? TheoryTableViewCell else { return }
            let viewModel = self.viewModel
            
            viewModel.toggleCompletion(of: &lesson, at: indexPath)
            cell.done = lesson.isFinished
            cell.setBackground()
            
            self.moveLesson(lesson, from: indexPath)
            
            completion(true)
        }
        
        action.backgroundColor = lesson.isFinished ? .systemRed : .systemGreen
        action.image = lesson.isFinished ? UIImage(systemName: "xmark.circle") : UIImage(systemName: "checkmark.circle")
        
        return action
    }
    
    private func moveLesson(_ lesson: Lesson, from indexPath: IndexPath) {
        switch viewModel.lessonsState {
        case .all, .none:
            if lesson.isFinished {
                self.moveLessonToBottom(lesson, from: indexPath)
            } else {
                self.moveLessonToTop(lesson, from: indexPath)
            }
        case .read, .unread:
            viewModel.removeLesson(at: indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func moveLessonToTop(_ lesson: Lesson, from indexPath: IndexPath) {
        moveRow(at: indexPath, to: IndexPath(row: 0, section: 0), with: lesson)
    }
    
    private func moveLessonToBottom(_ lesson: Lesson, from indexPath: IndexPath) {
        let lastIndexPath = IndexPath(row: viewModel.lastLessonIndex(), section: 0)
        moveRow(at: indexPath, to: lastIndexPath, with: lesson)
    }
    
    private func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath, with lesson: Lesson) {
        tableView.moveRow(at: indexPath, to: newIndexPath)
        viewModel.removeLesson(at: indexPath)
        viewModel.insert(lesson, at: newIndexPath)
    }
}
