//
//  SituationViewModel.swift
//  FirstAid
//
//  Created by Anna Shanidze on 10.01.2022.
//

import Foundation

class SituationsViewModel {
    
    let db = DatabaseManager()
    var situations: [SituationDB]?
    
    func loadSituations() {
        if !UserDefaults.standard.bool(forKey: "QuestExecuteOnce") {
            if let data = DataHelper.shared.loadJson(filename: "graph") {
                guard let situationsJSON = try? JSONDecoder().decode(Situations.self, from: data) else { return }
                db.addQuestsToCoreData(situationsJSON)
            }
            situations = db.loadSituations()
        }
    }
    
    func numberOfRows() -> Int {
        return situations!.count
    }
    
    //    func saveEnding(id: Int, isFinished: Bool, isSuccess: Bool) {
    //        situations?[id].isFinished = isFinished
    //        situations?[id].isSuccess = isSuccess
    //        DataHelper.shared.saveData(situations, at: dataFilePath)
    //    }
    
    
    #warning("переделать в свойство")
    func selectedSituation(at indexPath: IndexPath) -> SituationDB {
        return (situations?[indexPath.row])!
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> SituationsTVCellViewModel? {
        let situation = situations![indexPath.row]
        return SituationsTVCellViewModel(situation: situation)
    }
    
    func viewModelForSelectedRow(for situation: SituationDB) -> SceneViewModel? {
        return SceneViewModel(situation)
    }
    
}
