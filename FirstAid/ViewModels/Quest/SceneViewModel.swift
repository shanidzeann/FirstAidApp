//
//  SceneViewModel.swift
//  FirstAid
//
//  Created by Anna Shanidze on 11.01.2022.
//

import Foundation

class SceneViewModel {
    
    var situation: SituationDB
    #warning("переместить id в структуру и файл")
    var id: Int?
    
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
    
    func choiceText(_ id: Int) -> String? {
        let choice = choices?[id] as? ChoiceDB
        return choice?.text
    }
    
    func nextSceneID(_ id: Int) -> Int? {
        let choice = choices?[id - 1] as? ChoiceDB
        return Int(choice?.destination ?? 0)
    }
    
    init(_ situation: SituationDB) {
        self.situation = situation
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
    
}
