//
//  LessonsContentViewTests.swift
//  LessonPOCUITests
//
//  Created by Abhishek Suryawanshi on 27/03/23.
//

import Foundation
import XCTest
@testable import LessonPOC

class LessonsContentViewTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }
    
    func testLessonsList() throws {
        
        let tablesQuery = app.tables
        let lessonCell = tablesQuery.cells.staticTexts["The Key To Success In iPhone Photography"]
        let exists = NSPredicate(format: "exists == 1")
    }
}
