//
//  LessonsServiceManager.swift
//  LessonPOC
//
//  Created by Abhishek Suryawanshi on 19/03/23.
//

import Foundation

typealias lessonsCompletionHander = Result<Lessons, CustomError>

protocol LessonsServiceProtocol {
    func executeFetchLessons(completion: @escaping(lessonsCompletionHander) -> Void)
}

class LessonsServiceManager {
    let httpClient: HTTPClient
    
    let reachability = NetworkManager()
    
    init(client: HTTPClient = HTTPClient()) {
        self.httpClient = client
    }
    func fetchLessonsRequest() -> URLRequest? {
        guard let url = URL(string: URLConstant.baseURL + URLConstant.lessons) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.get.rawValue
        return request
    }
}

extension LessonsServiceManager: LessonsServiceProtocol {
    func executeFetchLessons(completion: @escaping(lessonsCompletionHander) -> Void) {
        guard let urlRequest = fetchLessonsRequest() else {
            completion(.failure(.invalidRequest))
            return
        }
        if reachability.isNetworkAvailable {
            httpClient.execute(with: urlRequest, completion: completion)
        } else {
            if let data: Lessons = httpClient.fetchDataFromLocalRepository(key: urlRequest.url?.lastPathComponent ?? "" )  {
                print("fetchced from local successfully")
                completion(.success(data))
            } else {
                completion(.failure(.invalidRequest))
            }
        }
        
    }
}


