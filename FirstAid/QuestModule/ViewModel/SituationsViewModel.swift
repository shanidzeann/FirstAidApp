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
        return situations?.count ?? 0
    }
    
    func loadSituations() {
        situations = db.loadSituations()
    }
    
    func saveEnding(situation: SituationDB, isFinished: Bool, isSuccess: Bool) {
        situation.isFinished = isFinished
        situation.isSuccess = isSuccess
        db.save()
    }
    
    func selectedSituation(at indexPath: IndexPath) -> SituationDB? {
        return situations?[indexPath.row]
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> SituationsTVCellViewModel? {
        guard let situation = situations?[indexPath.row] else { return nil }
        return SituationsTVCellViewModel(situation: situation)
    }
    
    func situationViewModel(for situation: SituationDB) -> SceneViewModel? {
        return SceneViewModel(situation)
    }
    
}
