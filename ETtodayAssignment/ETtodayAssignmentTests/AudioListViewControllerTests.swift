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
    
    init(audioLoader: AudioLoader) {
        self.audioLoader = audioLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

final class AudioListViewControllerTests: XCTestCase {
    
    func test_init_doesNotRequestAudioes() {
        let loader = AudioLoaderSpy()
        _ = AudioListViewController(audioLoader: loader)
        
        XCTAssertEqual(loader.receivedKeywords, [])
    }
    
    // MARK: - Helpers
    
    private class AudioLoaderSpy: AudioLoader {
        private(set) var receivedKeywords = [String]()
        
        func loadAudio(with keyword: String) {
            receivedKeywords.append(keyword)
        }
    }
}
