//
//  AudioListViewController.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import UIKit
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
