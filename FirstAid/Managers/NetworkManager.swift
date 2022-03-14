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
                self?.state = .noResults
                completion(.failure(error))
            } else if let data = data {
                self?.parseJSON(data: data, completion: { (result: Result<APIResponse, Error>) in
                    switch result {
                    case .success(let articles):
                        self?.state = .results
                        completion(.success(articles.articles))
                    case .failure(let error):
                        self?.state = .noResults
                        completion(.failure(error))
                    }
                })
            }
        }
        task.resume()
    }
    
    private func parseJSON<T: Decodable>(data: Data, completion: @escaping (Result<T, Error>) -> Void)  {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            completion(.success(result))
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            completion(.failure(DecodingError.dataCorrupted(context)))
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            completion(.failure(DecodingError.keyNotFound(key, context)))
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            completion(.failure(DecodingError.valueNotFound(value, context)))
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            completion(.failure(DecodingError.typeMismatch(type, context)))
        } catch {
            completion(.failure(error))
        }
    }

}








