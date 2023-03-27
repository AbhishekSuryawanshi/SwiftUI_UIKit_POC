//
//  CustomErrors.swift
//  LessonPOC
//
//  Created by Abhishek Suryawanshi on 19/03/23.
//

import Foundation

enum CustomError: Error {
    case invalidRequest
    case invalidJson
    case unknown
    case noData
    case general(message: String)
    
    var description: String {
        switch self {
        case .invalidRequest:
            return  "Something went wrong, please try again"
        case .invalidJson:
            return  "Something went wrong, please try again"
        case .unknown:
            return "Something went wrong, please try again"
        case .noData:
            return "Something went wrong, please try again"
        case .general(let message):
            return message
        }
    }
}
