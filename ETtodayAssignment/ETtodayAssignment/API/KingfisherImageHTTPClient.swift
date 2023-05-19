//
//  KingfisherImageHTTPClient.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/18.
//

import Kingfisher

final class KingfisherImageHTTPClient: HTTPClient {
    private let manager: KingfisherManager
    
    init(manager: KingfisherManager) {
        self.manager = manager
    }
    
    private struct UnexpectedCompletionError: Error {}
    private struct KingfisherImageHTTPClientTask: HTTPClientTask {
        var task: DownloadTask?
        
        func cancel() {
            task?.cancel()
        }
    }
    
    func dispatch(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        guard let url = request.url else {
            return KingfisherImageHTTPClientTask()
        }
        
        let task = manager.retrieveImage(with: url) { result in
            switch result {
            case let .success(data):
                guard let imageData = data.image.pngData(), let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else {
                    return completion(.failure(UnexpectedCompletionError()))
                }
                completion(.success((imageData, response)))
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
        return KingfisherImageHTTPClientTask(task: task)
    }
}
