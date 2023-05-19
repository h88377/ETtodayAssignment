//
//  AudioListCellViewController.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import UIKit
import RxSwift
import RxCocoa

final class AudioListCellViewController {
    private let id = UUID()
    private var cell: AudioListCell?
    
    private let isPlaying = BehaviorRelay<Bool>(value: false)
    private var isPlayingSubscription: Disposable?
    private var imageSubscription: Disposable?
    private var didEndPlayingSubscription: Disposable?
    
    private let audio: Audio
    private let viewModel: AudioListCellViewModel<UIImage>
    
    init(audio: Audio, viewModel: AudioListCellViewModel<UIImage>) {
        self.audio = audio
        self.viewModel = viewModel
    }
    
    func view(in collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AudioListCell.identifier, for: indexPath) as? AudioListCell else { return UICollectionViewCell() }
        
        cell.longDescriptionLabel.text = audio.longDescription
        cell.playImageView.isSelected = false
        cell.prepareForReuseHandler = { [weak cell, weak self] in
            cell?.audioImageView.image = nil
            self?.cancelTask()
        }
        
        self.cell = cell
        return cell
    }
    
    func requestImageData() {
        setUpBindings()
        viewModel.requestImageData(with: audio.imageURL)
    }
    
    func didSelect() {
        guard let cell = cell else { return }
        
        isPlaying.accept(!cell.playImageView.isSelected)
        
        let previewURL = audio.previewURL
        if isPlaying.value {
            viewModel.play(with: previewURL)
        } else {
            viewModel.pause(for: previewURL)
        }
    }
    
    func cancelSelection() {
        if isPlaying.value == true {
            viewModel.pause(for: audio.previewURL)
        }
        isPlaying.accept(false)
    }
    
    private func cancelTask() {
        viewModel.cancelTask()
        releaseBindings()
    }
    
    private func setUpBindings() {
        imageSubscription = viewModel.image
            .subscribe(onNext: { [weak cell] image in
                cell?.audioImageView.image = image
            })
        
        didEndPlayingSubscription = viewModel.didEndPlaying
            .subscribe(onNext: { [weak self] in
                self?.isPlaying.accept(false)
            })
        
        isPlayingSubscription = isPlaying
            .subscribe(onNext: { [weak cell] isPlaying in
                cell?.playImageView.isSelected = isPlaying
            })
    }
    
    private func releaseBindings() {
        imageSubscription?.dispose()
        didEndPlayingSubscription?.dispose()
        isPlayingSubscription?.dispose()
    }
}

extension AudioListCellViewController: Hashable {
    static func == (lhs: AudioListCellViewController, rhs: AudioListCellViewController) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
}
