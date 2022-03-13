//
//  NewsTVCellViewModel.swift
//  FirstAid
//
//  Created by Anna Shanidze on 03.02.2022.
//

import Foundation

class NewsTVCellViewModel {
    
    let networkManager = NetworkManager()
    private var article: Article
    
    var title: String {
        return article.title
    }
    
    var desctiption: String {
        return article.description ?? ""
    }
    
    var imageURL: String? {
        return article.urlToImage
    }
    
    init(article: Article) {
        self.article = article
    }
    
}


