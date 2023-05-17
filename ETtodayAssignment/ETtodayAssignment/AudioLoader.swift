//
//  AudioLoader.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import Foundation

struct Audio: Hashable {
    let imageURL: URL
    let previewURL: URL
    var longDescription: String?
}

protocol AudioLoader {
    typealias Result = Swift.Result<[Audio], Error>
    
    func loadAudio(with keyword: String, completion: @escaping (Result) -> Void)
}
