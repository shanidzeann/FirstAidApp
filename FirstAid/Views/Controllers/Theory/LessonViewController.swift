//
//  LessonViewController.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 23.10.2021.
//

import UIKit

class LessonViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Represents a cell type to handle lesson text
    enum LessonCellType {
        case image, text
    }
    
    var text: [String]?
    var titleText: String?
    var cellType: LessonViewController.LessonCellType?
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(LessonImageTableViewCell.self, forCellReuseIdentifier: LessonImageTableViewCell.identifier)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        titleLabel.text = titleText
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
}


// MARK: - TableView data source

extension LessonViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return text?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let paragraph = text![indexPath.row]
        
        if paragraph.hasPrefix("image") {
            cellType = .image
            let cell = tableView.dequeueReusableCell(withIdentifier: LessonImageTableViewCell.identifier, for: indexPath) as! LessonImageTableViewCell
            cell.image = UIImage(named: paragraph)
            return cell
            
        } else {
            cellType = .text
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = paragraph
            cell.textLabel?.numberOfLines = 0
            cell.selectionStyle = .none
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
        switch cellType {
        case .image, .none:
            return 200
        case .text:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
