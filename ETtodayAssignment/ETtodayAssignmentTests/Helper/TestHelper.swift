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
    
    func simulateAudioImageViewSelected(at index: Int) {
        let delegate = collectionView.delegate
        delegate?.collectionView?(collectionView, didSelectItemAt: IndexPath(item: index, section: audioSection))
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

extension AudioListCell {
    var renderedImageData: Data? {
        return audioImageView.image?.pngData()
    }
    
    var isShowingPlayView: Bool {
        return playImageView.isSelected == false
    }
    
    var isShowingPauseView: Bool {
        return playImageView.isSelected == true
    }
}

extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        return UIGraphicsImageRenderer(size: rect.size, format: format).image { rendererContext in
            color.setFill()
            rendererContext.fill(rect)
        }
    }
}
