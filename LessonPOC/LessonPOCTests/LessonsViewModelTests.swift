//
//  LessonsViewModelTests.swift
//  LessonPOCTests
//
//  Created by Abhishek Suryawanshi on 26/03/23.
//

import Foundation

import XCTest
@testable import LessonPOC

class LessonsViewModelTests: XCTestCase {
    
    var viewModel: LessonsViewModel!
    var lessonsServiceMock: LessonsServiceMock!
    
    override func setUp() {
        super.setUp()
    
        lessonsServiceMock = LessonsServiceMock()
        viewModel = LessonsViewModel(service: lessonsServiceMock)
    }
    
    func testFetchLessonsSuccess() {
        
        let expectedLessons = [
            Lesson(id: 1, name: "Lesson 1",
                   description: "Description for Lesson 1", thumbnail: "thumbnail1.jpg", video_url: "lesson1.mp4"),
            Lesson(id: 2, name: "Lesson 1",
                   description: "Description for Lesson 1", thumbnail: "thumbnail1.jpg", video_url: "lesson1.mp4")
        ]
        
        // set up the mock to return a successful result with expected lessons
        lessonsServiceMock.fetchLessonsResult = .success(Lessons(lessons: expectedLessons))
        
        var receivedLessons: [Lesson] = [
            Lesson(id: 1, name: "Lesson 1",
                   description: "Description for Lesson 1", thumbnail: "thumbnail1.jpg", video_url: "lesson1.mp4"),
            Lesson(id: 2, name: "Lesson 1",
                   description: "Description for Lesson 1", thumbnail: "thumbnail1.jpg", video_url: "lesson1.mp4")
        ]
        viewModel.lessonsClosure = { lessons in
            receivedLessons = lessons
        }

        
        var loaderShown = false
        viewModel.displayLoader = { isShown in
            loaderShown = isShown
        }
    
        viewModel.fetchLessons()
        
        // check if the loader was not displayed during the request
        XCTAssertTrue(!loaderShown)
        
        // check if the lessons were updated correctly
        XCTAssertEqual(receivedLessons, expectedLessons)
        XCTAssertEqual(receivedLessons, expectedLessons)
    }
    
    func testFetchLessonsFailure() {
        let expectedError = CustomError.unknown
        
        // set up the mock to return a failure with expected error
        lessonsServiceMock.fetchLessonsResult = .failure(expectedError)
        
        var receivedError: String?
        viewModel.showError = { error in
            receivedError = error
        }
        
        var loaderShown = false
        viewModel.displayLoader = { isShown in
            loaderShown = isShown
        }
        
        viewModel.fetchLessons()
        
        // check if the loader was not displayed during the request
        XCTAssertTrue(!loaderShown)
        
        // check if the error was shown correctly
        XCTAssertEqual(receivedError, expectedError.description)
    }
}

// Mock implementation of LessonsServiceProtocol for testing
class LessonsServiceMock: LessonsServiceProtocol {
    var fetchLessonsResult: Result<Lessons, CustomError>?
    
    func executeFetchLessons(completion: @escaping (Result<Lessons, CustomError>) -> ()) {
        if let result = fetchLessonsResult {
            completion(result)
        }
    }
}


