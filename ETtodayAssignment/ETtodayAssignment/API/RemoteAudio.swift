//
//  RemoteAudio.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/18.
//

import Foundation

struct RemoteAudio: Decodable {
    let imageURL: URL
    let previewURL: URL
    var longDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "artworkUrl100"
        case previewURL = "previewUrl"
        case longDescription
    }
}
