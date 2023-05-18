//
//  AudioListViewController+TestHelper.swift
//  ETtodayAssignmentTests
//
//  Created by 鄭昭韋 on 2023/5/18.
//

import UIKit
@testable import ETtodayAssignment

extension AudioListViewController {
    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        
        // To prevent diffable data source invoke cellForRowAt once it had enough space
        collectionView.frame = .init(x: 0, y: 1, width: 1, height: 1)
    }
    
    func simulateInputKeyword(with keyword: String) {
        let delegate = searchBar.delegate
        delegate?.searchBar?(searchBar, textDidChange: keyword)
    }
    
    @discardableResult
    func simulateAudioImageViewIsVisible(at index: Int) -> AudioListCell? {
        let dataSource = collectionView.dataSource
        let view = dataSource?.collectionView(collectionView, cellForItemAt: IndexPath(item: index, section: audioSection))
        return view as? AudioListCell
    }
    
    func itemAt(index: Int) -> UICollectionViewCell? {
        let dataSource = collectionView.dataSource
        return dataSource?.collectionView(collectionView, cellForItemAt: IndexPath(item: index, section: audioSection))
    }
    
    var numberOfAudios: Int {
        let dataSource = collectionView.dataSource!
        return dataSource.collectionView(collectionView, numberOfItemsInSection: audioSection)
    }
    
    var isShowingErrorReminder: Bool {
        return collectionView.isHidden && reminder.text == AudioListReminder.onError.rawValue
    }
    
    var isShowingEmptyReminder: Bool {
        return collectionView.isHidden && reminder.text == AudioListReminder.onEmpty.rawValue
    }
    
    private var audioSection: Int { return 0 }
}
