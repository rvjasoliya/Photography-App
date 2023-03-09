//
//  LessonsUITests.swift
//  LessonsUITests
//
//  Created by iMac on 07/03/23.
//

import XCTest

class LessonsUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        app.terminate()
    }
    
    func testLessonListView() {
        
        app.launch()
        
        let navigationBar = app.navigationBars["Lessons"]
        XCTAssertTrue(navigationBar.exists)
        
        let homeList = app.tables["lessonsList"]
        XCTAssertTrue(homeList.exists)

        let firstCell = app.tables["lessonsList"].cells.firstMatch
        firstCell.tap()
        
        sleep(3)
        
        let backButton = app.buttons["Lessons"]        
        backButton.tap()
        
        sleep(3)
        
        firstCell.tap()
        
        sleep(3)
        
        let nextLessonButton = app.buttons["Next Lesson"]
        nextLessonButton.tap()
        
        sleep(3)
        
        let downloadButton = app.buttons["Download Button"]
        downloadButton.tap()
        
        sleep(3)
        
        downloadButton.tap()
        
                
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
}
