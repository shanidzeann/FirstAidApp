//
//  ViewModel.swift
//  FirstAid
//
//  Created by Anna Shanidze on 19.12.2021.
//

import Foundation

enum MenuState {
    case read, unread, all
}

class TheoryViewModel: TheoryViewModelType {
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TheoryTVCellViewModelType? {
        let lesson = filteredLessons![indexPath.row]
        return TheoryTVCellViewModel(lesson: lesson)
    }
    
    var numberOfRows: Int {
        return filteredLessons!.count
    }
    
    var allLessons: [Lesson]?
    var filteredLessons: [Lesson]?
    
    var menuState: MenuState?
    
    let allDataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("AllTheory.plist")
    
    //   var jsonData: Data?
    
    func createLessons() {
        if let data = DataHelper.shared.loadJson(filename: "theory") {
            if !UserDefaults.standard.bool(forKey: "TheoryExecuteOnce") {
                allLessons = DataHelper.shared.createPlist(from: data, at: allDataFilePath)
                UserDefaults.standard.set(true, forKey: "TheoryExecuteOnce")
            }
        }
    }
    
    func loadLessons() {
        // TODO: - подумать башкой
        allLessons = DataHelper.shared.loadData(from: allDataFilePath)
        filteredLessons = allLessons?.sorted { !$0.isFinished && $1.isFinished }
    }
    
    func filterLessons(at index: Int) {
        //  guard var viewModel = self?.viewModel else { return }
        
        loadLessons()
        guard let allLessons = allLessons else { return }
        
        switch index {
        case 0:
            menuState = .read
            filteredLessons = (allLessons.filter { $0.isFinished == true })
        case 1:
            menuState = .unread
            filteredLessons = (allLessons.filter { $0.isFinished == false })
        default:
            menuState = .all
            filteredLessons = allLessons.sorted { !$0.isFinished && $1.isFinished }
        }
    }
    
    func selectedLesson(at indexPath: IndexPath) -> Lesson {
        return filteredLessons![indexPath.row]
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
            DataHelper.shared.saveData(allLessons, at: allDataFilePath)
        }
        
    }
    
}
