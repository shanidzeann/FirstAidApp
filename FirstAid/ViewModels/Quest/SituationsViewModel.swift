//
//  SituationViewModel.swift
//  FirstAid
//
//  Created by Anna Shanidze on 10.01.2022.
//

import Foundation

class SituationsViewModel {
    
    // MARK: - Properties
    
    let db = DatabaseManager()
    var situations: [SituationDB]?
    
    // MARK: - Methods
    
    func numberOfRows() -> Int {
        return situations!.count
    }
    
    func loadSituations() {
        if !UserDefaults.standard.bool(forKey: "QuestExecuteOnce") {
            if let data = DataHelper.shared.loadJson(filename: "graph") {
                guard let situationsJSON = try? JSONDecoder().decode(Situations.self, from: data) else { return }
                db.addQuestsToCoreData(situationsJSON)
                UserDefaults.standard.set(true, forKey: "QuestExecuteOnce")
            }
        }
        situations = db.loadSituations()
    }
    
    func saveEnding(situation: SituationDB, isFinished: Bool, isSuccess: Bool) {
        situation.isFinished = isFinished
        situation.isSuccess = isSuccess
        db.save()
    }
    
    func selectedSituation(at indexPath: IndexPath) -> SituationDB {
        return (situations?[indexPath.row])!
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> SituationsTVCellViewModel? {
        let situation = situations![indexPath.row]
        return SituationsTVCellViewModel(situation: situation)
    }
    
    func viewModelForSelectedRow(for situation: SituationDB, delegate: ViewModelDelegate?) -> SceneViewModel? {
        return SceneViewModel(situation, delegate: delegate)
    }
    
}


// MARK: - Receive data about quest completion

#warning("норм ли так делать в мввм")
extension SituationsViewModel: ViewModelDelegate {
    func endReceived(situation: SituationDB, isFinished: Bool, isSuccess: Bool) {
        saveEnding(situation: situation, isFinished: isFinished, isSuccess: isSuccess)
    }
    
}
