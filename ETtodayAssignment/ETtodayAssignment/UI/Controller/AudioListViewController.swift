//
//  AudioListViewController.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import UIKit

final class AudioListViewController: UICollectionViewController {
    let searchBar = UISearchBar()
    let reminder = UILabel()
    
    private let viewModel: AudioListViewModel
    
    init(viewModel: AudioListViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: .init())
    }
    
    private var audioSection: Int { return 0 }
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, AudioListCellViewController> = {
        .init(collectionView: collectionView) { [weak self] collectionView, indexPath, controller in
            return controller.view(in: collectionView, indexPath: indexPath)
        }
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        collectionView.dataSource = dataSource
        collectionView.register(AudioListCell.self, forCellWithReuseIdentifier: AudioListCell.identifier)
    }
    
    func set(audios: [AudioListCellViewController]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AudioListCellViewController>()
        snapshot.appendSections([audioSection])
        snapshot.appendItems(audios)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func setReminder(_ type: AudioListReminder) {
        reminder.text = type.rawValue
    }
}

extension AudioListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.loadAudios(with: searchText)
    }
}
