//
//  MainThreadDispatchDecorator.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/18.
//

import Foundation

final class MainThreadDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { completion() }
        }
        
        completion()
    }
}

extension MainThreadDispatchDecorator: AudioLoader where T == AudioLoader {
    func loadAudio(with keyword: String, completion: @escaping (AudioLoader.Result) -> Void) {
        decoratee.loadAudio(with: keyword) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainThreadDispatchDecorator: AudioImageDataLoader where T == AudioImageDataLoader {
    func loadImageData(from url: URL, completion: @escaping (AudioImageDataLoader.Result) -> Void) -> AudioImageDataLoaderTask {
        return decoratee.loadImageData(from: url) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
