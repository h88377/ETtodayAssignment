//
//  AudioListViewController.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import UIKit

final class AudioListCellViewController {
    private let id = UUID()
    private let audio: Audio
    
    init(audio: Audio) {
        self.audio = audio
    }
    
    func view(in collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AudioListCell.identifier, for: indexPath) as? AudioListCell else { return UICollectionViewCell() }
        
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

final class AudioListViewController: UICollectionViewController {
    let searchBar = UISearchBar()
    let reminder = UILabel()
    
    func set(audios: [AudioListCellViewController]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AudioListCellViewController>()
        snapshot.appendSections([audioSection])
        snapshot.appendItems(audios)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func setReminder(_ type: AudioListReminder) {
        reminder.text = type.rawValue
    }
    
    private var audioSection: Int { return 0 }
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, AudioListCellViewController> = {
        .init(collectionView: collectionView) { [weak self] collectionView, indexPath, controller in
            return controller.view(in: collectionView, indexPath: indexPath)
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
            switch result {
            case let .success(audios):
                let controllers = audios.map { AudioListCellViewController(audio: $0) }
                self?.set(audios: controllers)
                self?.collectionView.isHidden = audios.isEmpty
                
                if audios.isEmpty {
                    self?.setReminder(.onEmpty)
                }
            case .failure:
                self?.collectionView.isHidden = true
                self?.setReminder(.onError)
            }
        }
    }
}
