//
//  ArticleViewModel.swift
//  FirstAid
//
//  Created by Anna Shanidze on 02.02.2022.
//

import Foundation

class ArticleViewModel {
    
    private var article: Article
    
    var title: String {
        return article.title
    }
    
    var desctiption: String {
        return article.description ?? ""
    }
    
    var url: String? {
        return article.url
    }
    
    var imageURL: String? {
        return article.urlToImage
    }
    
    init(article: Article) {
        self.article = article
    }
    
}
