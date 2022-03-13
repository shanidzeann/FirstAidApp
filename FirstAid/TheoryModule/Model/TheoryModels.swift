//
//  TheoryModels.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 26.10.2021.
//

import Foundation

/// Represents a first aid lesson
struct Lesson: Codable {
    let title: String
    let text: [String] // array of paragraphs (text + image names)
    var isFinished: Bool
}


