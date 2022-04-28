//
//  LessonViewController+UITableViewDataSource.swift
//  FirstAid
//
//  Created by Anna Shanidze on 28.04.2022.
//

import UIKit

extension LessonViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let paragraph = viewModel?.paragraph(at: indexPath) else { return UITableViewCell() }
        switch viewModel?.cellType(for: indexPath) {
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.CellIdentifiers.lessonTextCell, for: indexPath)
            cell.textLabel?.text = paragraph
            cell.textLabel?.numberOfLines = 0
            cell.selectionStyle = .none
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.CellIdentifiers.lessonImageCell, for: indexPath) as! LessonImageTableViewCell
            let cellVM = viewModel?.imageCellViewModel(for: paragraph)
            cell.viewModel = cellVM
            return cell
        case .none:
            return UITableViewCell()
        }
    }
    
}
