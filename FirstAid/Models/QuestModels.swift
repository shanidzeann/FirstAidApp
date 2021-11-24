//
//  QuestModels.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 26.10.2021.
//

import Foundation

// MARK: - Situation

/// Represents a first aid situation (quest)
struct Situation: Codable {
    let title: String
    let scene: [Scene]
}

// MARK: - Scene

/// Represents a scene - current part of quest
struct Scene: Codable {
    let text: String
    let choices: [Choice]?
    let isHappyEnd: Bool
}

// MARK: - Choice

/// Represents possible answer
struct Choice: Codable {
    let text: String
    let destination: Int? // next scene id
}

typealias Situations = [Situation]

// MARK: - Situation for plist

/// Represents Situation struct for persisting data in plist
struct SituationPlist: Codable {
    let title: String
    var isFinished: Bool
    var isSuccess: Bool
}

