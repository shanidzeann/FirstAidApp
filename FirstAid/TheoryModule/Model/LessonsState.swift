//
//  LessonsState.swift
//  FirstAid
//
//  Created by Anna Shanidze on 28.04.2022.
//

import Foundation

enum LessonsState: Int, CaseIterable {
    case read
    case unread
    case all
    
    static let mapper: [LessonsState: String] = [
        .read: "Показать прочитанные",
        .unread: "Показать непрочитанные",
        .all: "Показать все"
    ]
    
    var title: String {
        return LessonsState.mapper[self] ?? ""
    }
}
