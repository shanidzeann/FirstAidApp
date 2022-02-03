//
//  NetworkManager.swift
//  FirstAid
//
//  Created by Anna Shanidze on 02.02.2022.
//

import Foundation

class NetworkManager {
    
    private(set) var state: State = .noResults
    
    let healthHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=ru&category=health&apiKey=\(yourKey)")
    
    func getArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        state = .loading
        guard let url = healthHeadlinesURL else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                completion(.failure(error))
                self?.state = .noResults
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    self?.state = .results
                    completion(.success(result.articles))
                } catch {
                    self?.state = .noResults
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}








