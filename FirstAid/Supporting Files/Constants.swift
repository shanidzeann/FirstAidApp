//
//  Constants.swift
//  FirstAid
//
//  Created by Anna Shanidze on 10.01.2022.
//

import Foundation

enum Constants {
    
    enum TableView {
        enum CellIdentifiers {
            static let questCell = "questCell"
            static let lessonTextCell = "lessonTextCell"
            static let theoryCell = "theoryCell"
            static let lessonImageCell = "lessonImageCell"
            static let resultCell = "ResultCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
        enum RowHeights {
            static let quest = 80.0
            static let news = 130.0
        }
    }
    
    enum URLs {
        static let healthHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=ru&category=health&apiKey=\(yourKey)")
    }
    
    enum SegueIdentifiers {
        static let sceneSegue = "sceneSegue"
        static let articleSegue = "articleSegue"
    }
    
    enum Animation {
        static let sceneDuration = 0.5
        static let alertDuration = 0.25
    }
    
    enum Timer {
        static let beginingValue = 15
        static let interval = 1.0
    }
    
    enum Images {
        enum BarButtonItems {
            static let pause = "pause.fill"
            static let restart = "gobackward"
            static let back = "chevron.backward"

        }
    }
    
    enum RulesAlert {
        static let height = 250.0
        static let spacing = 5.0
        static let titleHeight = 60.0
        static let messageHeight = 130.0
        static let widthSpace = 60.0
        static let title = "Правила"
        static let text = "Твоя задача - оказать первую помощь и спасти постравшего. Будь внимателен, время ответа ограничено."
    }
    
    enum Layout {
        static let newsSpacing = 20.0
    }
}
