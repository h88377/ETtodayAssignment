//
//  AudioListViewController.swift
//  ETtodayAssignment
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import UIKit

final class AudioListViewController: UIViewController {
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let reminder: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var audioSection: Int { return 0 }
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, AudioListCellViewController> = {
        .init(collectionView: collectionView) { [weak self] collectionView, indexPath, controller in
            return controller.view(in: collectionView, indexPath: indexPath)
        }
    }()
    
    private var selectedCellController: AudioListCellViewController?
    private let viewModel: AudioListViewModel
    
    init(viewModel: AudioListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        view.backgroundColor = .white
        searchBar.delegate = self
        configureCollectionView()
        configureDismissKeyboard()
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
    
    private func setUpUI() {
        view.addSubviews([collectionView, searchBar])
        view.insertSubview(reminder, belowSubview: collectionView)
        
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
        
        reminder.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = configureCollectionViewLayout()
        collectionView.register(AudioListCell.self, forCellWithReuseIdentifier: AudioListCell.identifier)
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func cellController(at index: Int) -> AudioListCellViewController? {
        guard dataSource.snapshot().itemIdentifiers.count > 0 else { return nil }
        
        let snapshot = dataSource.snapshot()
        return snapshot.itemIdentifiers(inSection: audioSection)[index]
    }
    
    private func configureDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UICollectionViewDelegate

extension AudioListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedCellController === cellController(at: indexPath.item) {
            cellController(at: indexPath.item)?.didSelect()
        } else {
            selectedCellController?.cancelSelection()
            cellController(at: indexPath.item)?.didSelect()
            selectedCellController = cellController(at: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cellController(at: indexPath.item)?.requestImageData()
    }
}

// MARK: - UISearchBarDelegate

extension AudioListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        selectedCellController?.cancelSelection()
        selectedCellController = nil
        viewModel.loadAudios(with: searchText)
    }
}
