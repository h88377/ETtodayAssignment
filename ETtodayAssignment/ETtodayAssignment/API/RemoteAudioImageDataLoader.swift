//
//  RemoteAudioImageDataLoader.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/18.
//

import Foundation

final class RemoteAudioImageDataLoader: AudioImageDataLoader {
    enum Error: Swift.Error {
        case invalidData
        case connectivity
    }
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImageData(from url: URL, completion: @escaping (AudioImageDataLoader.Result) -> Void) {
        client.dispatch(URLRequest(url: url)) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                guard response.statusCode == 200, !data.isEmpty else {
                    return completion(.failure(Error.invalidData))
                }
                
                completion(.success(data))
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
