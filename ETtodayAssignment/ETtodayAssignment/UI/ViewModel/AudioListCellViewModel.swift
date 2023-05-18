//
//  AudioListCellViewModel.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import RxCocoa

final class AudioListCellViewModel<Image> {
    let image = PublishRelay<Image>()
    let didEndPlaying = PublishRelay<Void>()
    
    private let imageDataLoader: AudioImageDataLoader
    private let imageTransformer: (Data) -> Image?
    private let audioPlayer: AudioPlayer
    
    init(imageDataLoader: AudioImageDataLoader, imageTransformer: @escaping (Data) -> Image?, audioPlayer: AudioPlayer) {
        self.imageDataLoader = imageDataLoader
        self.imageTransformer = imageTransformer
        self.audioPlayer = audioPlayer
    }
    
    func requestImageData(with url: URL) {
        imageDataLoader.loadImageData(from: url) { [weak self] result in
            if let data = try? result.get(), let image = self?.imageTransformer(data) {
                self?.image.accept(image)
            }
        }
    }
    
    func play(with url: URL) {
        audioPlayer.play(with: url) { [weak self] in
            self?.didEndPlaying.accept(())
        }
    }
    
    func pause(for url: URL) {
        audioPlayer.pause(for: url)
    }
}
