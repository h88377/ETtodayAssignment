//
//  ETtodayAssignmentTests.swift
//  ETtodayAssignmentTests
//
//  Created by 鄭昭韋 on 2023/5/17.
//

import XCTest
@testable import ETtodayAssignment

final class AudioListUIIntegrationTests: XCTestCase {
    
    func test_init_doesNotRequestAudioes() {
        let (_, loader, _) = makeSUT()
        
        XCTAssertEqual(loader.receivedKeywords, [])
    }
    
    func test_inputKeywordActions_requestAudioesWithKeyword() {
        let firstKeyword = "keywordOne"
        let secondKeyword = "keywordOne"
        let (sut, loader, _) = makeSUT()
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
        let (sut, loader, _) = makeSUT()
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
        let (sut, loader, _) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateInputKeyword(with: anyKeyword())
        loader.complete(with: anyNSError())
        
        XCTAssertTrue(sut.isShowingErrorReminder)
    }
    
    func test_audioImageView_loadsImageURLWhenVisible() {
        let imageURL = anyURL()
        let audio = makeAudio(imageURL: imageURL)
        let (sut, loader, _) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateInputKeyword(with: anyKeyword())
        loader.completeSuccessfully(with: [audio])
        
        sut.simulateAudioImageViewIsVisible(at: 0)
        XCTAssertEqual(loader.receivedURLs, [imageURL])
    }
    
    func test_audioImageView_rendersSuccessfullyLoadedImage() {
        let audio = makeAudio(imageURL: anyURL())
        let (sut, loader, _) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateInputKeyword(with: anyKeyword())
        loader.completeSuccessfully(with: [audio])
        
        let view = sut.simulateAudioImageViewIsVisible(at: 0)
        XCTAssertNil(view?.renderedImageData)
        
        let imageData = UIImage.make(withColor: .red).pngData()!
        loader.completeImageDataSuccessfully(with: imageData)
        
        XCTAssertEqual(view?.renderedImageData, imageData)
    }
    
    func test_audioImageView_doesNotAlterImageStateOnError() {
        let (sut, loader, _) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateInputKeyword(with: anyKeyword())
        loader.completeSuccessfully(with: [makeAudio()])
        
        let view = sut.simulateAudioImageViewIsVisible(at: 0)
        XCTAssertNil(view?.renderedImageData)
        
        loader.completeImageData(with: anyNSError())
        XCTAssertNil(view?.renderedImageData)
    }
    
    func test_audioPlayView_showsPlayOrPauseViewWhenSelectingViewAccordingly() {
        let (sut, loader, _) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateInputKeyword(with: anyKeyword())
        loader.completeSuccessfully(with: [makeAudio(), makeAudio()])
        
        let view0 = sut.simulateAudioImageViewIsVisible(at: 0)
        let view1 = sut.simulateAudioImageViewIsVisible(at: 1)
        XCTAssertEqual(view0?.isShowingPlayView, true)
        XCTAssertEqual(view1?.isShowingPlayView, true)
        
        sut.simulateAudioImageViewSelected(at: 0)
        XCTAssertEqual(view0?.isShowingPauseView, true)
        XCTAssertEqual(view1?.isShowingPlayView, true)
        
        sut.simulateAudioImageViewSelected(at: 0)
        XCTAssertEqual(view0?.isShowingPlayView, true)
        XCTAssertEqual(view1?.isShowingPlayView, true)
        
        sut.simulateAudioImageViewSelected(at: 1)
        XCTAssertEqual(view0?.isShowingPlayView, true)
        XCTAssertEqual(view1?.isShowingPauseView, true)
    }
    
    func test_audioPlayView_showsPlayViewWhenTypingKeywords() {
        let (sut, loader, _) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateInputKeyword(with: anyKeyword())
        loader.completeSuccessfully(with: [makeAudio()])
        
        let view = sut.simulateAudioImageViewIsVisible(at: 0)
        XCTAssertEqual(view?.isShowingPlayView, true)
        
        sut.simulateAudioImageViewSelected(at: 0)
        XCTAssertEqual(view?.isShowingPauseView, true)
        
        sut.simulateInputKeyword(with: anyKeyword())
        XCTAssertEqual(view?.isShowingPlayView, true)
    }
    
    func test_audioPlayView_showsPlayViewWhenFinishingPlaying() {
        let (sut, loader, player) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateInputKeyword(with: anyKeyword())
        loader.completeSuccessfully(with: [makeAudio()])
        
        let view0 = sut.simulateAudioImageViewIsVisible(at: 0)
        XCTAssertEqual(view0?.isShowingPlayView, true)
        
        sut.simulateAudioImageViewSelected(at: 0)
        XCTAssertEqual(view0?.isShowingPauseView, true)
        
        player.completePlaying(at: 0)
        XCTAssertEqual(view0?.isShowingPlayView, true)
    }
    
    func test_audioPlayView_pausesAudioPlayingWhenTypingKeyword() {
        let imageURL = URL(string: "https://image-url.com")!
        let (sut, loader, player) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateInputKeyword(with: anyKeyword())
        loader.completeSuccessfully(with: [makeAudio(previewURL: imageURL)])
        
        sut.simulateAudioImageViewIsVisible(at: 0)
        XCTAssertEqual(player.receivedPlayURL, [])
        XCTAssertEqual(player.receivedPauseURL, [])
        
        sut.simulateAudioImageViewSelected(at: 0)
        XCTAssertEqual(player.receivedPlayURL, [imageURL])
        XCTAssertEqual(player.receivedPauseURL, [])
        
        sut.simulateInputKeyword(with: anyKeyword())
        
        XCTAssertEqual(player.receivedPlayURL, [imageURL])
        XCTAssertEqual(player.receivedPauseURL, [imageURL])
    }
    
    func test_audioPlayView_requestsPlayOrPauseWhenSelectingViewAccordingly() {
        let firstPlayURL = URL(string: "https://first-play-url.com")!
        let secondPlayURL = URL(string: "https://second-play-url.com")!
        let (sut, loader, player) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateInputKeyword(with: anyKeyword())
        loader.completeSuccessfully(with: [makeAudio(previewURL: firstPlayURL), makeAudio(previewURL: secondPlayURL)])
        
        sut.simulateAudioImageViewIsVisible(at: 0)
        sut.simulateAudioImageViewIsVisible(at: 1)
        XCTAssertEqual(player.receivedPlayURL, [])
        XCTAssertEqual(player.receivedPauseURL, [])
        
        sut.simulateAudioImageViewSelected(at: 0)
        XCTAssertEqual(player.receivedPlayURL, [firstPlayURL])
        XCTAssertEqual(player.receivedPauseURL, [])
        
        sut.simulateAudioImageViewSelected(at: 0)
        XCTAssertEqual(player.receivedPlayURL, [firstPlayURL])
        XCTAssertEqual(player.receivedPauseURL, [firstPlayURL])
        
        sut.simulateAudioImageViewSelected(at: 1)
        XCTAssertEqual(player.receivedPlayURL, [firstPlayURL, secondPlayURL])
        XCTAssertEqual(player.receivedPauseURL, [firstPlayURL])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (AudioListViewController, AudioLoaderSpy, AudioPlayerSpy) {
        let loader = AudioLoaderSpy()
        let player = AudioPlayerSpy()
        let sut = AudioListUIComposer.AudioUIComposedWith(audioLoader: loader, audioPlayer: player,  imageDataLoader: loader)
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(loader, file: file, line: line)
        trackForMemoryLeak(player, file: file, line: line)
        return (sut, loader, player)
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
        private var receivedImageCompletions = [(AudioImageDataLoader.Result) -> Void]()
        
        func loadImageData(from url: URL, completion: @escaping (AudioImageDataLoader.Result) -> Void) {
            receivedURLs.append(url)
            receivedImageCompletions.append(completion)
        }
        
        func completeImageDataSuccessfully(with data: Data, at index: Int = 0) {
            receivedImageCompletions[index](.success(data))
        }
        
        func completeImageData(with error: Error, at index: Int = 0) {
            receivedImageCompletions[index](.failure(error))
        }
    }
    
    private class AudioPlayerSpy: AudioPlayer {
        private(set) var receivedPlayURL = [URL]()
        private(set) var receivedPauseURL = [URL]()
        private var receivedPlayCompletions = [() -> Void]()
        
        func play(with url: URL, completion: @escaping (() -> Void)) {
            receivedPlayURL.append(url)
            receivedPlayCompletions.append(completion)
        }
        
        func pause(for url: URL) {
            receivedPauseURL.append(url)
        }
        
        func completePlaying(at index: Int) {
            receivedPlayCompletions[index]()
        }
    }

}
