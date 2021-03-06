//
//  NewsViewModel.swift
//  FirstAid
//
//  Created by Anna Shanidze on 02.02.2022.
//

import Foundation

class NewsViewModel {
    
    let networkManager: NetworkManager
    private var articles: [Article]?
    
    var state: State {
        return networkManager.state
    }
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func numberOfRows() -> Int {
        switch networkManager.state {
        case .loading, .noResults:
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
        let jsonParser = JSONParser()
        let networkManager = NetworkManager(jsonParser: jsonParser)
        return NewsTVCellViewModel(article: article, networkManager: networkManager)
    }
    
    func articleViewModel(for article: Article) -> ArticleViewModel? {
        return ArticleViewModel(article: article)
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
    
}
