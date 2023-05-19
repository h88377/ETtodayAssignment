//
//  AVPlayerAudioPlayer.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/18.
//

import AVFoundation

final class AVPlayerAudioPlayer: StreamingAudioPlayer {
    private var player: AVPlayer?
    private var playerDidFinishHandler: (() -> Void)?
    
    init() {
        NotificationCenter.default
            .addObserver(self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func play(with url: URL, completion: @escaping (() -> Void)) {
        playerDidFinishHandler = completion
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.volume = 1.0
        player?.play()
    }
    
    func pause(for url: URL) {
        player?.pause()
    }
    
    func resume() {
        player?.play()
    }
    
    @objc private func playerDidFinishPlaying() {
        player?.seek(to: .zero)
        playerDidFinishHandler?()
    }
}
