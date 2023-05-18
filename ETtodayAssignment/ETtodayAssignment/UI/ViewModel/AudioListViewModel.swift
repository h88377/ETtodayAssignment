//
//  AudioListViewModel.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import RxCocoa

final class AudioListViewModel {
    let audios = PublishRelay<[Audio]>()
    let reminder = PublishRelay<AudioListReminder>()
    
    private let audioLoader: AudioLoader
    
    init(audioLoader: AudioLoader) {
        self.audioLoader = audioLoader
    }
    
    func loadAudios(with keyword: String) {
        audioLoader.loadAudio(with: keyword) { [weak self] result in
            switch result {
            case let .success(audios):
                if audios.isEmpty {
                    self?.reminder.accept(.onEmpty)
                }
                self?.audios.accept(audios)
                
            case .failure:
                self?.reminder.accept(.onError)
            }
        }
    }
}
