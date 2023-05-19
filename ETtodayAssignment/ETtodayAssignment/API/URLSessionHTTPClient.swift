//
//  URLSessionHTTPClient.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/18.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedCompletionError: Error {}
    private struct URLSessionHTTPClientTask: HTTPClientTask {
        let task: URLSessionTask
        
        func cancel() {
            task.cancel()
        }
    }
    
    func dispatch(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(UnexpectedCompletionError()))
            }
        }
        task.resume()
        return URLSessionHTTPClientTask(task: task)
    }
}
