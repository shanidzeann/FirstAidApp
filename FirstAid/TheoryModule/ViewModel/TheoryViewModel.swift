//
//  ViewModel.swift
//  FirstAid
//
//  Created by Anna Shanidze on 19.12.2021.
//

import Foundation

class TheoryViewModel {
    
    // MARK: - Properties
    
    var dataHelper: DataHelper
    
    var allLessons: [Lesson]?
    var filteredLessons: [Lesson]?
    var lessonsState: LessonsState?
    
    let titleForHeader = "Первая помощь при ..."
    let allDataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("AllTheory.plist")
    
    init(dataHelper: DataHelper) {
        self.dataHelper = dataHelper
    }
    
    // MARK: - Work with lessons
    
    func numberOfRows() -> Int {
        return filteredLessons?.count ?? 0
    }
    
    func createLessonsFileIfFirstLaunch() {
        if let data = dataHelper.loadJson(filename: "theory") {
            if !UserDefaults.standard.bool(forKey: "TheoryExecuteOnce") {
                createLessonsFile(data: data)
                UserDefaults.standard.set(true, forKey: "TheoryExecuteOnce")
            }
        }
    }
    
    private func createLessonsFile(data: Data) {
        dataHelper.createPlist(from: data, at: allDataFilePath, completion: { (result: Result<[Lesson], Error>) in
            switch result {
            case .success(let lessons):
                self.allLessons = lessons
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func loadLessons() {
        allLessons = dataHelper.loadData(from: allDataFilePath)
        filteredLessons = allLessons?.sorted { !$0.isFinished && $1.isFinished }
    }
    
    func refreshFilteredLessons() {
        filteredLessons = allLessons?.sorted { !$0.isFinished && $1.isFinished }
    }
    
    func filterLessons(by state: LessonsState) {
        refreshFilteredLessons()
        guard let allLessons = allLessons else { return }
        
        lessonsState = state
        switch state {
        case .read:
            filteredLessons = (allLessons.filter { $0.isFinished == true })
        case .unread:
            filteredLessons = (allLessons.filter { $0.isFinished == false })
        case .all:
            filteredLessons = allLessons.sorted { !$0.isFinished && $1.isFinished }
        }
    }
    
    func selectedLesson(at indexPath: IndexPath) -> Lesson? {
        return filteredLessons?[indexPath.row]
    }
    
    func removeLesson(at indexPath: IndexPath) {
        filteredLessons?.remove(at: indexPath.row)
    }
    
    func insert(_ lesson: Lesson, at indexPath: IndexPath) {
        filteredLessons?.insert(lesson, at: indexPath.row)
    }
    
    func toggleCompletion(of lesson: inout Lesson, at indexPath: IndexPath) {
        
        let done = lesson.isFinished
        filteredLessons?[indexPath.row].isFinished = !done
        lesson.isFinished = !done
        
        // find selected item in all lessons
        if let itemID = allLessons?.firstIndex(where: {$0.title == lesson.title}) {
            allLessons?[itemID].isFinished = !done
            dataHelper.saveData(allLessons, at: allDataFilePath)
        }
    }
    
    func lastLessonIndex() -> Int {
        return (filteredLessons?.count ?? 1) - 1
    }
    
    // MARK: - Get ViewModels
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TheoryTVCellViewModel? {
        guard let lesson = filteredLessons?[indexPath.row] else { return nil }
        return TheoryTVCellViewModel(lesson: lesson)
    }
    
    func lessonViewModel(for lesson: Lesson) -> LessonViewModel? {
        return LessonViewModel(lesson)
    }
    
}
