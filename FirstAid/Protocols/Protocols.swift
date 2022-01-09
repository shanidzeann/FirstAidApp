//
//  Protocols.swift
//  FirstAid
//
//  Created by Anna Shanidze on 01.01.2022.
//

import Foundation

protocol TheoryViewModelType {
    func numberOfRows() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TheoryTVCellViewModelType?
    
    var allLessons: [Lesson]? { get set }
    var filteredLessons: [Lesson]? { get set }
    
    func createLessons()
    func loadLessons()
    func filterLessons(at index: Int)
    func selectedLesson(at indexPath: IndexPath) -> Lesson
    func removeLesson(at indexPath: IndexPath)
    func toggleCompletion(of lesson: inout Lesson, at indexPath: IndexPath)
    func insert(_ lesson: Lesson, at indexPath: IndexPath)
    func lessonViewModel(for lesson: Lesson) -> LessonViewModel?
    
    var allDataFilePath: URL? { get }
    
    var menuState: MenuState? { get set }
}

protocol TheoryTVCellViewModelType: AnyObject {
    var title: String { get }
    var done: Bool { get }
}
