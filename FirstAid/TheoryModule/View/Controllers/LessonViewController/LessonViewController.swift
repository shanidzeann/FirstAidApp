//
//  LessonViewController.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 23.10.2021.
//

import UIKit

class LessonViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: LessonViewModel? {
        willSet(viewModel) {
            titleLabel.text = viewModel?.titleText
        }
    }
    
    // MARK: - UI
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.TableView.CellIdentifiers.lessonTextCell)
        tableView.register(LessonImageTableViewCell.self, forCellReuseIdentifier: Constants.TableView.CellIdentifiers.lessonImageCell)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        return tableView
    }()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBackgroundColor()
        addTableView()
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .red
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(didTapCancel))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.titleView = titleLabel
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    private func addTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

}
