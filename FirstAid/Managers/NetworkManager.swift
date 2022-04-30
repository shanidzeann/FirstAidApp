//
//  NetworkManager.swift
//  FirstAid
//
//  Created by Anna Shanidze on 02.02.2022.
//

import Foundation

class NetworkManager {
    
    private var jsonParser: JSONParser
    
    private(set) var state: State = .noResults {
        didSet {
            postNotification()
        }
    }
    
    init(jsonParser: JSONParser) {
        self.jsonParser = jsonParser
    }
    
    func getArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        state = .loading
        guard let url = Constants.URLs.healthHeadlinesURL else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                self?.state = .noResults
                completion(.failure(error))
            } else if let data = data {
                self?.jsonParser.parseJSON(data: data) { (result: Result<APIResponse, Error>) in
                    switch result {
                    case .success(let articles):
                        self?.state = .results
                        completion(.success(articles.articles))
                    case .failure(let error):
                        self?.state = .noResults
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
    
    private func postNotification() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("lessonsStateChanged"), object: nil)
        }
    }

}
