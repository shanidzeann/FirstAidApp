//
//  LessonViewModel.swift
//  FirstAid
//
//  Created by Anna Shanidze on 09.01.2022.
//

import Foundation

class LessonViewModel {
    
    // MARK: - Properties
    
    enum LessonCellType {
        case image, text
    }
    
    private var lesson: Lesson
    
    var text: [String] {
        return lesson.text
    }
    
    var titleText: String {
        return "Первая помощь при " + lesson.title.lowercased()
    }
    
    // MARK: - Init
    
    init(_ lesson: Lesson) {
        self.lesson = lesson
    }
    
    // MARK: - Methods
    
    func numberOfRows() -> Int {
        return text.count
    }
    
    func paragraph(at indexPath: IndexPath) -> String {
        return text[indexPath.row]
    }
    
    func cellType(for indexPath: IndexPath) -> LessonCellType {
        let paragraph = paragraph(at: indexPath)
        
        if paragraph.hasPrefix("image") {
            return .image
        } else {
            return .text
        }
    }
    
    func imageCellViewModel(for paragraph: String) -> LessonTVCellViewModel {
        return LessonTVCellViewModel(imageName: paragraph)
    }
}
