//
//  LessonTests.swift
//  LessonPOCTests
//
//  Created by Abhishek Suryawanshi on 26/03/23.
////
//
import Foundation
import XCTest
@testable import LessonPOC


class LessonTests: XCTestCase {

    func testLessonInitialization() {
        let lesson = Lesson(id: 1, name: "Lesson 1",
                            description: "Description for Lesson 1", thumbnail: "thumbnail1.jpg", video_url: "lesson1.mp4")

        XCTAssertEqual(lesson.id, 1)
        XCTAssertEqual(lesson.name, "Lesson 1")
        XCTAssertEqual(lesson.description, "Description for Lesson 1")
        XCTAssertEqual(lesson.thumbnail, "thumbnail1.jpg")
        XCTAssertEqual(lesson.video_url, "lesson1.mp4")
    }
}
