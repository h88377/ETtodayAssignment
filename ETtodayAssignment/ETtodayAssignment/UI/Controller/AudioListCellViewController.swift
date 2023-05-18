//
//  AudioListCellViewController.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import UIKit
import RxSwift

final class AudioListCellViewController {
    private let id = UUID()
    private let disposeBag = DisposeBag()
    private var cell: AudioListCell?
    
    private let audio: Audio
    private let viewModel: AudioListCellViewModel<UIImage>
    
    init(audio: Audio, viewModel: AudioListCellViewModel<UIImage>) {
        self.audio = audio
        self.viewModel = viewModel
    }
    
    func view(in collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AudioListCell.identifier, for: indexPath) as? AudioListCell else { return UICollectionViewCell() }
        
        viewModel.requestImageData(with: audio.imageURL)
        
        viewModel.image
            .subscribe(onNext: { [weak cell] image in
                cell?.audioImageView.image = image
            }).disposed(by: disposeBag)
        
        viewModel.didEndPlaying
            .subscribe(onNext: { [weak cell] in
                cell?.playImageView.isSelected = false
            }).disposed(by: disposeBag)
        
        cell.longDescriptionLabel.text = audio.longDescription
        cell.playImageView.isSelected = false
        self.cell = cell
        return cell
    }
    
    func didSelect() {
        guard let cell = cell else { return }
        
        cell.playImageView.isSelected = !cell.playImageView.isSelected
        
        let previewURL = audio.previewURL
        if cell.playImageView.isSelected {
            viewModel.play(with: previewURL)
        } else {
            viewModel.pause(for: previewURL)
        }
    }
    
    func cancelSelection() {
        if cell?.playImageView.isSelected == true {
            viewModel.pause(for: audio.previewURL)
        }
        cell?.playImageView.isSelected = false
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
