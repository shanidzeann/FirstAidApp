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
    
    // MARK: - Helper Methods
    
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
}


// MARK: - Table view delegate

