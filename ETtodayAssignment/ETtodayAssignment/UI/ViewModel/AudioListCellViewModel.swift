//
//  AudioListCellViewModel.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import RxCocoa

final class AudioListCellViewModel<Image> {
    let image = PublishRelay<Image>()
    private let imageDataLoader: AudioImageDataLoader
    private let imageTransformer: (Data) -> Image?
    
    init(imageDataLoader: AudioImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.imageDataLoader = imageDataLoader
        self.imageTransformer = imageTransformer
    }
    
    func requestImageData(with url: URL) {
        imageDataLoader.loadImageData(from: url) { [weak self] result in
            if let data = try? result.get(), let image = self?.imageTransformer(data) {
                self?.image.accept(image)
            }
        }
    }
}
