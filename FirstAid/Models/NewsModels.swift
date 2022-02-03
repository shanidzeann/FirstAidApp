//
//  NewsModels.swift
//  FirstAid
//
//  Created by Anna Shanidze on 03.02.2022.
//

import Foundation

struct APIResponse: Codable {
    let articles: [Article]
}

class Article: Codable {
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

enum State {
    case loading
    case noResults
    case results
}
