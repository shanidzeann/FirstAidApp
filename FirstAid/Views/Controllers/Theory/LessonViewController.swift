//
//  LessonViewController.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 23.10.2021.
//

import UIKit

class LessonViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: LessonViewModel! {
        willSet(viewModel) {
            titleLabel.text = viewModel.titleText
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.tableViewCell.rawValue)
        tableView.register(LessonImageTableViewCell.self, forCellReuseIdentifier: LessonImageTableViewCell.identifier)
        tableView.separatorStyle = .none
        
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
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .red
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(didTapCancel))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.titleView = titleLabel
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    func addTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

}


// MARK: - TableView data source

extension LessonViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let paragraph = viewModel.paragraph(at: indexPath)
        switch viewModel.cellType(for: indexPath) {
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.tableViewCell.rawValue, for: indexPath)
            cell.textLabel?.text = paragraph
            cell.textLabel?.numberOfLines = 0
            cell.selectionStyle = .none
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: LessonImageTableViewCell.identifier, for: indexPath) as! LessonImageTableViewCell
            let cellVM = viewModel.imageCellViewModel(for: paragraph)
            cell.viewModel = cellVM
            return cell
        }
    }
}


// MARK: - TableView delegate

extension LessonViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // TODO: Fix images
        switch viewModel.cellType(for: indexPath) {
        case .image:
            return 200
        case .text:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}