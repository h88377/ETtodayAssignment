//
//  StreamingAudioPlayer.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/19.
//

import Foundation

protocol StreamingAudioPlayer {
    func play(with url: URL, completion: @escaping (() -> Void))
    func pause(for url: URL)
    func resume()
}
