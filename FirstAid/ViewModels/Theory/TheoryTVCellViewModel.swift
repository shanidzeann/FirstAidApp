//
//  TablewViewCellViewModel.swift
//  FirstAid
//
//  Created by Anna Shanidze on 01.01.2022.
//

import Foundation

class TheoryTVCellViewModel: TheoryTVCellViewModelType {
 //   var text: String
    
    var title: String {
        return lesson.title
    }

    var done: Bool {
        return lesson.isFinished
    }
    
    private var lesson: Lesson
//    var title: String
//    var done: Bool
    
    init(lesson: Lesson) {
        self.lesson = lesson
//        self.title = lesson.title
//        self.done = lesson.isFinished
    }
}

//cell.textLabel?.text = viewModel.filteredLessons?[indexPath.row].title
//
//        if let done = viewModel.filteredLessons?[indexPath.row].isFinished {
//            cell.backgroundColor = done ? UIColor(red: 0, green: 0.4, blue: 0, alpha: 0.5) : .systemBackground
//        }
