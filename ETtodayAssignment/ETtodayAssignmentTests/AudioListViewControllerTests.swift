//
//  ETtodayAssignmentTests.swift
//  ETtodayAssignmentTests
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import XCTest
@testable import ETtodayAssignment

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
    
    func test_inputKeywordCompletions_rendersSuccessfulyAudios() {
        let firstKeyword = "keywordOne"
        let secondKeyword = "keywordTwo"
        let thirdKeyword = "keywordThree"
        let firstAudios = [makeAudio()]
        let secondAudios = [makeAudio(), makeAudio(longDescription: "longDescription")]
        let emptyAuduo = [Audio]()
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateInputKeyword(with: firstKeyword)
        loader.completeSuccessfully(with: firstAudios)
        assertThat(sut, isRendering: firstAudios)
        
        sut.simulateInputKeyword(with: secondKeyword)
        loader.completeSuccessfully(with: secondAudios)
        assertThat(sut, isRendering: secondAudios)
        
        sut.simulateInputKeyword(with: thirdKeyword)
        loader.completeSuccessfully(with: emptyAuduo)
        assertThat(sut, isRendering: emptyAuduo)
        XCTAssertTrue(sut.isShowingEmptyReminder)
    }
    
    func test_inputKeywordCompletions_showsErrorReminderOnError() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateInputKeyword(with: anyKeyword())
        loader.complete(with: anyNSError())
        
        XCTAssertTrue(sut.isShowingErrorReminder)
    }
    
    func test_audioImageView_loadsImageURLWhenVisible() {
        let imageURL = anyURL()
        let audio = makeAudio(imageURL: imageURL)
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateInputKeyword(with: anyKeyword())
        loader.completeSuccessfully(with: [audio])
        
        sut.simulateAudioImageViewIsVisible(at: 0)
        XCTAssertEqual(loader.receivedURLs, [imageURL])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (AudioListViewController, AudioLoaderSpy) {
        let loader = AudioLoaderSpy()
        let sut = AudioListUIComposer.AudioUIComposedWith(audioLoader: loader, imageDataLoader: loader)
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(loader, file: file, line: line)
        return (sut, loader)
    }
    
    private func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: AudioListViewController, isRendering audios: [Audio], file: StaticString = #filePath, line: UInt = #line) {
        guard audios.count == sut.numberOfAudios else {
            return XCTFail("Expected \(audios.count), got \(sut.numberOfAudios) instead", file: file, line: line)
        }
        
        for (index, audio) in audios.enumerated() {
            assertThat(sut, hasViewConfiguredFor: audio, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: AudioListViewController, hasViewConfiguredFor audio: Audio, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.itemAt(index: index)
        guard let cell = view as? AudioListCell else {
            return XCTFail("Expected \(AudioListCell.self) instance, got \(String(describing: view.self)) instead", file: file, line: line)
        }
        
        XCTAssertEqual(cell.longDescriptionLabel.text, audio.longDescription, "Expected longDescription text should be \(String(describing: audio.longDescription)) at index \(index)", file: file, line: line)
    }
    
    private func makeAudio(imageURL: URL = URL(string: "https://image-url.com")!, previewURL: URL = URL(string: "https://image-url.com")!, longDescription: String? = nil) -> Audio {
        return Audio(imageURL: imageURL, previewURL: previewURL, longDescription: longDescription)
    }
    
    private func anyKeyword() -> String {
        return "anyKeyword"
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any NSError", code: 0)
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://any-url.com")!
    }
    
    private class AudioLoaderSpy: AudioLoader, AudioImageDataLoader {
        
        // MARK: - AudioLoader
        
        private(set) var receivedKeywords = [String]()
        private var receivedCompletions = [(AudioLoader.Result) -> Void]()
        
        func loadAudio(with keyword: String, completion: @escaping (AudioLoader.Result) -> Void) {
            receivedKeywords.append(keyword)
            receivedCompletions.append(completion)
        }
        
        func completeSuccessfully(with audios: [Audio], at index: Int = 0) {
            receivedCompletions[index](.success(audios))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            receivedCompletions[index](.failure(error))
        }
        
        // MARK: - AudioImageDataLoader
        
        private(set) var receivedURLs = [URL]()
        
        func loadImageData(from url: URL, completion: @escaping (AudioImageDataLoader.Result) -> Void) {
            receivedURLs.append(url)
        }
    }
}

private extension AudioListViewController {
    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        
        // To prevent diffable data source invoke cellForRowAt once it had enough space
        collectionView.frame = .init(x: 0, y: 1, width: 1, height: 1)
    }
    
    func simulateInputKeyword(with keyword: String) {
        let delegate = searchBar.delegate
        delegate?.searchBar?(searchBar, textDidChange: keyword)
    }
    
    func simulateAudioImageViewIsVisible(at index: Int) {
        let dataSource = collectionView.dataSource
        dataSource?.collectionView(collectionView, cellForItemAt: IndexPath(item: index, section: audioSection))
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
