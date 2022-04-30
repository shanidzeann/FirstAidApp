//
//  JSONManager.swift
//  FirstAid
//
//  Created by Анна Шанидзе on 26.10.2021.
//

import Foundation

class DataHelper {
     
    private var jsonParser: JSONParser
    
    init(jsonParser: JSONParser) {
        self.jsonParser = jsonParser
    }

    func loadJson(filename fileName: String) -> Data? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: url)
                return jsonData
            } catch {
                print("Error loading JSON:\(error)")
            }
        }
        return nil
    }
    
    func createPlist<T: Codable>(from jsonData: Data, at path: URL?, completion: @escaping (Result<[T], Error>) -> Void) {
        jsonParser.parseJSON(data: jsonData) { [weak self] (result: Result<[T], Error>) in
            switch result {
            case .success(let plist):
                self?.saveData(plist, at: path)
                completion(.success(plist))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveData<T: Codable>(_ plist: T, at path: URL?) {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(plist)
            try data.write(to: path!)
        } catch {
            print("Error encoding: \(error)")
        }
    }
    
    func loadData<T: Codable> (from path: URL?) -> T? {
        if let data = try? Data(contentsOf: path!) {
            let decoder = PropertyListDecoder()
            do {
                let plist = try decoder.decode(T.self, from: data)
                return plist
            } catch {
                print("Error decoding: \(error)")
            }
        }
        return nil
    }

}
