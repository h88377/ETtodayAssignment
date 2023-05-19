//
//  SceneDelegate.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import UIKit
import SnapKit
import AVFAudio

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = makeAudioListViewController()
        
        self.window = window
        window.makeKeyAndVisible()
        
        enablePlayback()
    }
}

private extension SceneDelegate {
    func makeAudioListViewController() -> AudioListViewController {
        let baseURL = URL(string: "https://itunes.apple.com/search")!
        let client = URLSessionHTTPClient()
        let audioLoader = RemoteAudioLoader(baseURL: baseURL, client: client)
        
        let streamingPlayer = AVPlayerAudioPlayer()
        let audioPlayer = RemoteAudioPlayer(player: streamingPlayer)
        
        let kingfisherClient = KingfisherImageHTTPClient(manager: .shared)
        let imageDataLoader = RemoteAudioImageDataLoader(client: kingfisherClient)
        
        return AudioListUIComposer.AudioUIComposedWith(audioLoader: audioLoader, audioPlayer: audioPlayer, imageDataLoader: imageDataLoader)
    }
    
    func enablePlayback() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
}
