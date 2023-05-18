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
    
    func dispatch(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) {
        guard let url = request.url else { return }
        
        manager.retrieveImage(with: url) { result in
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
    }
}
