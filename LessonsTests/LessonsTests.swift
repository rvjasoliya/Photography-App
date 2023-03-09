//
//  LessonsTests.swift
//  LessonsTests
//
//  Created by iMac on 07/03/23.
//

import XCTest
@testable import Lessons

class LessonsTests: XCTestCase {
    
    let lessonsViewModel = LessonsViewModel.shared
    
    override class func setUp() {
        super.setUp()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }
    
    func testNeworkIsConnected() {
        let network = Network()
        network.checkConnection()
        let cb = expectation(description: "Network Connection Fetch")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            cb.fulfill()
        }
        
        // Then
        wait(for: [cb], timeout: 5)
        XCTAssertTrue(network.connected)
    }
    
    func testFetchLessonsData() {
        lessonsViewModel.fetchLessons()
        XCTAssertTrue(!lessonsViewModel.lessons.isEmpty)
        XCTAssertNotNil(lessonsViewModel.lessons)
    }
    
    func testVideoDownload() async {
        XCTAssertTrue(!lessonsViewModel.lessons.isEmpty)
        XCTAssertNotNil(lessonsViewModel.lessons)
        let url = URL(string: lessonsViewModel.lessons[0].video_url)!
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = docsUrl?.appendingPathComponent(url.lastPathComponent)
        let lessonDetails = await LessonDetails(lessonsViewModel: lessonsViewModel, destinationUrl: destinationUrl!)
        await lessonDetails.downloadFile()
        XCTAssertTrue(lessonsViewModel.lessons[0].isVideoDownloading ?? false)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
