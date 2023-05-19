//
//  AVPlayerAudioPlayer.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/18.
//

import AVFoundation

protocol StreamingAudioPlayer {
    func play(with url: URL, completion: @escaping (() -> Void))
    func pause(for url: URL)
    func resume()
}

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
