//
//  AudioPlayer.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/18.
//

import Foundation

protocol AudioPlayer {
    func play(with url: URL, completion: @escaping (() -> Void))
    func pause()
}
