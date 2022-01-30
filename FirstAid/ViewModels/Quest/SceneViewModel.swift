//
//  SceneViewModel.swift
//  FirstAid
//
//  Created by Anna Shanidze on 11.01.2022.
//

import Foundation
import UIKit

class SceneViewModel {
    
    var situation: SituationDB
    var valueDidChangeClosure: (() -> Void)?
    #warning("переместить id в структуру и файл")
    var id: Int?
    
    var scene: SceneDB? {
        didSet {
            valueDidChangeClosure?()
        }
    }
    
    var text: String? {
        return scene?.text
    }
    
    var end: Bool? {
        return scene?.isHappyEnd
    }
    
    var choices: NSOrderedSet? {
        return scene?.choices
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
        scene = situation.scenes?[0] as? SceneDB
    }

    func setNextScene(_ tag: Int) {
        let id = nextSceneID(tag)
        if let nextSceneID = id {
            scene = situation.scenes?[nextSceneID] as? SceneDB
        }
    }
    
    func setLastScene() {
        scene = situation.scenes?.lastObject as? SceneDB
    }
    
}
