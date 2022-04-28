//
//  LessonViewController+UITableViewDelegate.swift
//  FirstAid
//
//  Created by Anna Shanidze on 28.04.2022.
//

import UIKit

extension LessonViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel?.cellType(for: indexPath) {
        case .image:
            return 200
        case .text, .none:
            return UITableView.automaticDimension
        }
    }
}
