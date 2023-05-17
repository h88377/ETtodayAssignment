//
//  AudioListCellViewController.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import UIKit
import RxCocoa

protocol AudioImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void)
}

final class AudioListCellViewModel {
    let imageData = PublishRelay<Data>()
    private let imageDataLoader: AudioImageDataLoader
    
    init(imageDataLoader: AudioImageDataLoader) {
        self.imageDataLoader = imageDataLoader
    }
    
    func requestImageData(with url: URL) {
        imageDataLoader.loadImageData(from: url) { _ in
        }
    }
}

final class AudioListCellViewController {
    private let id = UUID()
    private let audio: Audio
    private let viewModel: AudioListCellViewModel
    
    init(audio: Audio, viewModel: AudioListCellViewModel) {
        self.audio = audio
        self.viewModel = viewModel
    }
    
    func view(in collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AudioListCell.identifier, for: indexPath) as? AudioListCell else { return UICollectionViewCell() }
        
        viewModel.requestImageData(with: audio.imageURL)
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
