//
//  TablewViewCellViewModel.swift
//  FirstAid
//
//  Created by Anna Shanidze on 01.01.2022.
//

import Foundation

class TheoryTVCellViewModel {
    
    var title: String {
        return lesson.title
    }

    var done: Bool {
        return lesson.isFinished
    }
    
    private var lesson: Lesson
    
    init(lesson: Lesson) {
        self.lesson = lesson
    }
}
