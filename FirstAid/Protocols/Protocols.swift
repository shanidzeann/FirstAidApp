//
//  Protocols.swift
//  FirstAid
//
//  Created by Anna Shanidze on 01.01.2022.
//

import Foundation

protocol ViewModelDelegate {
    func endReceived(situation: SituationDB, isFinished: Bool, isSuccess: Bool)
}
