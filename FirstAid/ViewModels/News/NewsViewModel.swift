//
//  NewsViewModel.swift
//  FirstAid
//
//  Created by Anna Shanidze on 02.02.2022.
//

import Foundation

class NewsViewModel {
    
    let networkManager = NetworkManager()
    private var articles: [Article]?
    
    var state: State {
        return networkManager.state
    }
    
    
    func getArticles(completion: @escaping () -> ()) {
        articles?.removeAll()
        networkManager.getArticles { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                completion()
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func numberOfRows() -> Int {
        switch networkManager.state {
        case .loading:
            return 1
        case .noResults:
            return 1
        case .results:
            return articles?.count ?? 0
        }
    }
    
    func selectedArticle(atIndexPath indexPath: IndexPath) -> Article? {
        return articles?[indexPath.row]
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> NewsTVCellViewModel? {
        guard let article = articles?[indexPath.row] else { return nil }
        return NewsTVCellViewModel(article: article)
    }
    
    func articleViewModel(for article: Article) -> ArticleViewModel? {
        return ArticleViewModel(article: article)
    }
    
}
