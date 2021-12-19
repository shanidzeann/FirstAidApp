//
//  QuestModels.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 26.10.2021.
//

import Foundation


/// Represents a first aid situation (quest)
struct Situation: Codable {
    let title: String
    let scene: [Scene]
}

typealias Situations = [Situation]

/// Represents a scene - current part of quest
struct Scene: Codable {
    let text: String
    let choices: [Choice]?
    let isHappyEnd: Bool
}

/// Represents possible answer
struct Choice: Codable {
    let text: String
    let destination: Int? // next scene id
}

/// Represents Situation struct for persisting data in plist
struct SituationPlist: Codable {
    let title: String
    var isFinished: Bool
    var isSuccess: Bool
}

