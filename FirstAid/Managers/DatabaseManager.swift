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
}
