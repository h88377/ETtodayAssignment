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
    
    private final class RemoteAudioImageDataLoaderTask: AudioImageDataLoaderTask {
        private var completion: ((AudioImageDataLoader.Result) -> Void)?
        var clientTask: HTTPClientTask?
        
        init(_ completion: @escaping (AudioImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(_ result: AudioImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
            clientTask?.cancel()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (AudioImageDataLoader.Result) -> Void) -> AudioImageDataLoaderTask {
        let loaderTask = RemoteAudioImageDataLoaderTask(completion)
        loaderTask.clientTask = client.dispatch(URLRequest(url: url)) { [weak self] result in
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
        return loaderTask
    }
}
