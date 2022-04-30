//
//  SceneViewModel.swift
//  FirstAid
//
//  Created by Anna Shanidze on 11.01.2022.
//

import Foundation

class SceneViewModel {
    
    // MARK: - Properties
    
    var databaseManager: DatabaseManager
    var situation: SituationDB
    lazy var scene = Box(situation.scenes?[0] as? SceneDB)
    
    var text: String? {
        return scene.value?.text
    }
    
    var end: Bool? {
        return scene.value?.isHappyEnd
    }
    
    var choices: NSOrderedSet? {
        return scene.value?.choices
    }
    
    // MARK: - Init
    
    init(_ situation: SituationDB, databaseManager: DatabaseManager) {
        self.situation = situation
        self.databaseManager = databaseManager
    }
    
    // MARK: - Methods
    
    func choiceText(_ id: Int) -> String? {
        let choice = choices?[id] as? ChoiceDB
        return choice?.text
    }
    
    func nextSceneID(_ id: Int) -> Int? {
        let choice = choices?[id - 1] as? ChoiceDB
        return Int(choice?.destination ?? 0)
    }
    
    func setFirstScene() {
        scene.value = situation.scenes?[0] as? SceneDB
    }
    
    func setNextScene(_ tag: Int) {
        let id = nextSceneID(tag)
        if let nextSceneID = id {
            scene.value = situation.scenes?[nextSceneID] as? SceneDB
        }
    }
    
    func setLastScene() {
        scene.value = situation.scenes?.lastObject as? SceneDB
    }
    
    func questIsFinished() -> Bool {
        return scene.value?.situation?.isFinished ?? false
    }
    
    func saveEnding(isFinished: Bool, isSuccess: Bool) {
        situation.isFinished = isFinished
        situation.isSuccess = isSuccess
        databaseManager.save()
    }
    
    func sceneHasChoices() -> Bool {
        return choices?.count == 3
    }
    
    func isHappyEnd() -> Bool {
         return scene.value?.isHappyEnd ?? false
    }
    
}
