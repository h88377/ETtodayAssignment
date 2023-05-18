//
//  AVPlayerAudioPlayer.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/18.
//

import AVFoundation

final class AVPlayerAudioPlayer: AudioPlayer {
    private var player: AVPlayer?
    private var playerDidFinishHandler: (() -> Void)?
    private var currentURL: URL? {
        return (player?.currentItem?.asset as? AVURLAsset)?.url
    }
    
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
        guard currentURL != url else {
            player?.play()
            return
        }
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.volume = 1.0
        player?.play()
    }
    
    func pause(for url: URL) {
        player?.pause()
    }
    
    @objc private func playerDidFinishPlaying() {
        playerDidFinishHandler?()
    }
}
