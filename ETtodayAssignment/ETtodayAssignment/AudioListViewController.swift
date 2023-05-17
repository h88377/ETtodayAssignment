//
//  AudioListViewController.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import UIKit

final class AudioListCell: UICollectionViewCell {
    static let identifier = "\(AudioListCell.self)"
    
    let longDescriptionLabel = UILabel()
}

final class AudioListViewController: UICollectionViewController {
    let searchBar = UISearchBar()
    
    func set(audios: [Audio]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Audio>()
        snapshot.appendSections([audioSection])
        snapshot.appendItems(audios)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private var audioSection: Int { return 0 }
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, Audio> = {
        .init(collectionView: collectionView) { [weak self] collectionView, indexPath, audio in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AudioListCell.identifier, for: indexPath) as? AudioListCell else { return UICollectionViewCell() }
            
            cell.longDescriptionLabel.text = audio.longDescription
            return cell
        }
    }()
    
    private let audioLoader: AudioLoader
    
    init(audioLoader: AudioLoader) {
        self.audioLoader = audioLoader
        super.init(collectionViewLayout: .init())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        collectionView.dataSource = dataSource
        collectionView.register(AudioListCell.self, forCellWithReuseIdentifier: AudioListCell.identifier)
    }
}

extension AudioListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        audioLoader.loadAudio(with: searchText) { [weak self] result in
            if let audios = try? result.get() {
                self?.set(audios: audios)
            }
        }
    }
}
