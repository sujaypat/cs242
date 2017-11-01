//
//  GitHub_ViewerUITests.swift
//  GitHub ViewerUITests
//
//  Created by Sujay Patwardhan on 10/19/17.
//  Copyright © 2017 Sujay Patwardhan. All rights reserved.
//

import XCTest

class GitHub_ViewerUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testVisitAllTabs() {
        XCUIDevice.shared().orientation = .portrait
        let app = XCUIApplication()
        app.launch()
        sleep(10)
        app.activate() // Go back to app
        sleep(5)
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Repos"].tap()
        tabBarsQuery.buttons["Following"].tap()
        tabBarsQuery.buttons["Followers"].tap()
    }
    
    func testStarRepo() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCUIDevice.shared().orientation = .portrait
        let app = XCUIApplication()
        app.launch()
        sleep(10)
        app.activate() // Go back to app
        sleep(5)
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Repos"].tap()
        
        let tablesQuery = XCUIApplication().tables
        tablesQuery.cells["seabuffalo, A C (sea) port of Buffalo."].swipeLeft()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Star/Unstar"]/*[[".cells[\"seabuffalo, A C (sea) port of Buffalo.\"].buttons[\"Star\/Unstar\"]",".buttons[\"Star\/Unstar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    func testUnfollowUser(){
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCUIDevice.shared().orientation = .portrait
        let app = XCUIApplication()
        app.launch()
        sleep(10)
        app.activate() // Go back to app
        sleep(5)
        
        app.tabBars.buttons["Following"].tap()
        let tablesQuery = XCUIApplication().tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["theishshah"]/*[[".cells[\"theishshah\"].staticTexts[\"theishshah\"]",".staticTexts[\"theishshah\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        sleep(1)
        tablesQuery/*@START_MENU_TOKEN@*/.cells["theishshah"].buttons["Unfollow"]/*[[".cells[\"theishshah\"].buttons[\"Unfollow\"]",".buttons[\"Unfollow\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        sleep(5)
        XCTAssert(app.tables.cells.count == 9)
    }
    
    func testFollowUser(){
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCUIDevice.shared().orientation = .portrait
        let app = XCUIApplication()
        app.launch()
        sleep(10)
        app.activate() // Go back to app
        sleep(5)
        
        app.tabBars.buttons["Following"].tap()
        app.navigationBars["Following"].buttons["Add"].tap()
        
        app.alerts["Follow"].typeText("theishshah")
        app.alerts["Follow"].buttons["OK"].tap()
        sleep(5)
        XCTAssert(app.tables.cells.count == 9)
    }
    
    
    
}
