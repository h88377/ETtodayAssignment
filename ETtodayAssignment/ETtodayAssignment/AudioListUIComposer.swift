//
//  AudioListUIComposer.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import RxSwift
import RxCocoa

final class AudioListUIComposer {
    private init() {}
    private static let disposeBag = DisposeBag()
    
    static func AudioUIComposedWith(audioLoader: AudioLoader) -> AudioListViewController {
        let viewModel = AudioListViewModel(audioLoader: audioLoader)
        let controller = AudioListViewController(viewModel: viewModel)
        
        viewModel.audios
            .subscribe(onNext: { [weak controller] audios in
                let cellControllers = audios.map { AudioListCellViewController(audio: $0) }
                controller?.set(audios: cellControllers)
                controller?.collectionView.isHidden = audios.isEmpty
            }).disposed(by: disposeBag)
        
        viewModel.reminder
            .subscribe(onNext: { [weak controller] reminder in
                controller?.setReminder(reminder)
                controller?.collectionView.isHidden = true
            }).disposed(by: disposeBag)
        
        return controller
    }
}
