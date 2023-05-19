//
//  RemoteAudioPlayer.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/19.
//

import Foundation

final class RemoteAudioPlayer: AudioPlayer {
    private var currentURL: URL?
    private let player: StreamingAudioPlayer
    
    init(player: StreamingAudioPlayer) {
        self.player = player
    }
    
    func play(with url: URL, completion: @escaping (() -> Void)) {
        guard currentURL != url else {
            player.resume()
            return
        }
        currentURL = url
        player.play(with: url, completion: completion)
    }
    
    func pause(for url: URL) {
        player.pause(for: url)
    }
}
