//
//  ETtodayAssignmentTests.swift
//  ETtodayAssignmentTests
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import XCTest
@testable import ETtodayAssignment

class AudioListViewController: UIViewController {
    private let audioLoader: AudioLoader
    let searchBar = UISearchBar()
    
    init(audioLoader: AudioLoader) {
        self.audioLoader = audioLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
}

extension AudioListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        audioLoader.loadAudio(with: searchText)
    }
}

final class AudioListViewControllerTests: XCTestCase {
    
    func test_init_doesNotRequestAudioes() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.receivedKeywords, [])
    }
    
    func test_inputKeywordActions_requestAudioesWithKeyword() {
        let firstKeyword = "keywordOne"
        let secondKeyword = "keywordOne"
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateInputKeyword(with: firstKeyword)
        sut.simulateInputKeyword(with: secondKeyword)
        
        XCTAssertEqual(loader.receivedKeywords, [firstKeyword, secondKeyword])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (AudioListViewController, AudioLoaderSpy) {
        let loader = AudioLoaderSpy()
        let sut = AudioListViewController(audioLoader: loader)
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(loader, file: file, line: line)
        return (sut, loader)
    }
    
    private func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    private class AudioLoaderSpy: AudioLoader {
        private(set) var receivedKeywords = [String]()
        
        func loadAudio(with keyword: String) {
            receivedKeywords.append(keyword)
        }
    }
}

private extension AudioListViewController {
    func simulateInputKeyword(with keyword: String) {
        let delegate = searchBar.delegate
        delegate?.searchBar?(searchBar, textDidChange: keyword)
    }
}
