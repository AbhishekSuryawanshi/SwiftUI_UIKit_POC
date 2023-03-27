//
//  HttpClient.swift
//  LessonPOC
//
//  Created by Abhishek Suryawanshi on 19/03/23.
//

import Foundation

protocol HTTPClientProtocol {
    func execute<T: Codable>(with request: URLRequest, completion: @escaping (Result<T, CustomError>) -> Void)
    func fetchDataFromLocalRepository<T: Codable>(key: String) -> T?
}

final class HTTPClient: HTTPClientProtocol {
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func execute<T: Codable>(with request: URLRequest, completion: @escaping (Result<T, CustomError>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let res = response as? HTTPURLResponse,
                  200..<400 ~= res.statusCode else {
                completion(.failure(.general(message: "response failed with other than ")))
                return
            }
            
            guard error == nil else {
                completion(.failure(.general(message: error?.localizedDescription ?? "something went wrong")))
                return
            }
            
            guard let responseData = data, responseData.isEmpty == false else {
                completion(.failure(.general(message: "response failed with other than ")))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(T.self, from: responseData)
                
                if let key = request.url?.lastPathComponent {
                    self.saveDataToLocalRepository(key: key, model: model)
                }
 
                completion(.success(model))
                
            } catch {
                completion(.failure(.invalidJson))
            }
        }
        task.resume()
    }
    
    func fetchDataFromLocalRepository<T: Codable>(key: String) -> T?  {
        let userDefaults = UserDefaults.standard
        if let savedPersonData = userDefaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let model = try? decoder.decode(T.self, from: savedPersonData) {
                return model
            }
            return nil
        }
        return nil
    }
    
    func saveDataToLocalRepository(key: String, model: Codable) {
        let userDefaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(model) {
            userDefaults.set(encoded, forKey: key)
            userDefaults.synchronize()
            print("saved to local successfully")
        }
    }
}

