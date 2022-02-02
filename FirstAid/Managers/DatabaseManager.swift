//
//  DatabaseManager.swift
//  FirstAid
//
//  Created by Anna Shanidze on 28.01.2022.
//

import Foundation
import UIKit
import CoreData

class DatabaseManager {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func loadSituations() -> [SituationDB]? {
        let request: NSFetchRequest<SituationDB> = SituationDB.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
            return nil
        }
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("Error saving data \(error)")
        }
    }
    
    func addQuestsToCoreData(_ quests: Situations) {
        #warning("n3")
        for quest in quests {
            let entity = NSEntityDescription.entity(forEntityName: "SituationDB", in: context)
            let newQuest = NSManagedObject(entity: entity!, insertInto: context) as! SituationDB
            
            newQuest.setValue(quest.title, forKey: "title")
            newQuest.setValue(quest.isFinished, forKey: "isFinished")
            newQuest.setValue(quest.isSuccess, forKey: "isSuccess")
            
            for scene in quest.scenes {
                let entity = NSEntityDescription.entity(forEntityName: "SceneDB", in: context)
                let newScene = NSManagedObject(entity: entity!, insertInto: context) as! SceneDB

                newQuest.addToScenes(newScene)
                newScene.setValue(scene.text, forKey: "text")
                newScene.setValue(scene.isHappyEnd, forKey: "isHappyEnd")

                if let choices = scene.choices {

                    for choice in choices {
                        let entity = NSEntityDescription.entity(forEntityName: "ChoiceDB", in: context)
                        let newChoice = NSManagedObject(entity: entity!, insertInto: context) as! ChoiceDB

                        newScene.addToChoices(newChoice)
                        newChoice.setValue(choice.text, forKey: "text")
                        newChoice.setValue(choice.destination, forKey: "destination")
                    }
                }
            }
        }
    }
}
