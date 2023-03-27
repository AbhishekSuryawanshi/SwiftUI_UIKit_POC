//
//  Lesson.swift
//  LessonPOC
//
//  Created by Abhishek Suryawanshi on 19/03/23.
//

import Foundation

struct Lessons: Codable, Equatable {
    let lessons: [Lesson]
}

struct Lesson: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: String
    let video_url: String
    
    static func == (lhs: Lesson, rhs: Lesson) -> Bool {
            guard let lhsData = try? JSONEncoder().encode(lhs),
                  let rhsData = try? JSONEncoder().encode(rhs)
            else {
                return false
            }
            return lhsData == rhsData
        }
}
