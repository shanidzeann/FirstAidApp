//
//  TheoryViewController+UITableViewDelegate.swift
//  FirstAid
//
//  Created by Anna Shanidze on 28.04.2022.
//

import UIKit

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
            
            switch viewModel.lessonsState {
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
    
    private func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath, with lesson: Lesson) {
        tableView.moveRow(at: indexPath, to: newIndexPath)
        viewModel.removeLesson(at: indexPath)
        viewModel.insert(lesson, at: newIndexPath)
    }

}
