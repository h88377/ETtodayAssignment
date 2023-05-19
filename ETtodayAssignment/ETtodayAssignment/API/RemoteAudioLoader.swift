//
//  RemoteAudioLoader.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/18.
//

import Foundation

final class RemoteAudioLoader: AudioLoader {
    typealias Result = AudioLoader.Result
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private let baseURL: URL
    private let client: HTTPClient
    
    init(baseURL: URL, client: HTTPClient) {
        self.baseURL = baseURL
        self.client = client
    }
    
    func loadAudio(with keyword: String, completion: @escaping (Result) -> Void) {
        let url = enrich(baseURL, with: keyword)
        client.dispatch(URLRequest(url: url)) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(RemoteAudioLoader.map(with: data, response))
                
            case .failure:
                completion(.failure(RemoteAudioLoader.Error.connectivity))
            }
        }
    }
    
    private func enrich(_ baseURL: URL, with keyword: String) -> URL {
        var component = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        component?.queryItems = [
            URLQueryItem(name: "term", value: keyword)
        ]
        
        return component?.url ?? baseURL
    }
    
    private static func map(with data: Data, _ response: HTTPURLResponse) -> Result {
        do {
            let remoteAudios = try AudiosMapper.map(with: data, response)
            return .success(remoteAudios.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteAudio {
    func toModels() -> [Audio] {
        var audios = [Audio]()
        for remote in self {
            if let imageURL = remote.imageURL, let previewURL = remote.previewURL {
                audios.append(Audio(imageURL: imageURL, previewURL: previewURL, longDescription: remote.longDescription))
            }
        }
        return audios
    }
}
