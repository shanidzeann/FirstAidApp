//
//  SituationsTVCellViewModel.swift
//  FirstAid
//
//  Created by Anna Shanidze on 10.01.2022.
//

import Foundation

class SituationsTVCellViewModel {
    
    var situation: SituationDB
    
    init(situation: SituationDB) {
        self.situation = situation
    }
    
    var title: String {
        return situation.title ?? ""
    }
    
    var isFinished: Bool {
        return situation.isFinished
    }
    
    var isSuccess: Bool {
        return situation.isSuccess
    }
    
}
