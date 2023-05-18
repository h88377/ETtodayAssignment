//
//  RemoteAudioLoader.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/18.
//

import Foundation

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func dispatch(_ request: URLRequest, completion: @escaping (Result) -> Void)
}

struct RemoteAudio: Decodable {
    let imageURL: URL
    let previewURL: URL
    var longDescription: String?
}

final class AudiosMapper {
    private init() {}
    
    private static var OK_200: Int { return 200 }
    
    static func map(with data: Data, _ response: HTTPURLResponse) throws -> [RemoteAudio] {
        guard response.statusCode == OK_200, let remoteAudios = try? JSONDecoder().decode([RemoteAudio].self, from: data) else {
            throw RemoteAudioLoader.Error.invalidData
        }
        
        return remoteAudios
    }
}

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
        return map { Audio(imageURL: $0.imageURL, previewURL: $0.previewURL, longDescription: $0.longDescription) }
    }
}
