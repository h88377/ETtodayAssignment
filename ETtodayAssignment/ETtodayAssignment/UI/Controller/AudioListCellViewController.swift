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
        
        cell.longDescriptionLabel.text = audio.longDescription
        return cell
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
