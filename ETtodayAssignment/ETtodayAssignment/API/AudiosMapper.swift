//
//  AudiosMapper.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/18.
//

import Foundation

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
