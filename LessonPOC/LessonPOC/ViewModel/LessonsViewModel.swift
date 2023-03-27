//
//  LessonsViewModel.swift
//  LessonPOC
//
//  Created by Abhishek Suryawanshi on 19/03/23.
//

import Foundation

class LessonsViewModel: ObservableObject {
    
   @Published var lessons: [Lesson] = [Lesson]()
    
    var showError: ((String) -> ())?
    var displayLoader: ((Bool) -> ())?
    var lessonsClosure: (([Lesson]) -> ())?

    let lessonsService: LessonsServiceProtocol
    
    init(service: LessonsServiceProtocol = LessonsServiceManager()) {
        self.lessonsService = service
    }
    
    func fetchLessons() {
        displayLoader?(true)
        lessonsService.executeFetchLessons() { [weak self] result in
            self?.displayLoader?(false)
            switch result {
            case .failure(let error):
                self?.showError?(error.description)
            case .success(let model):
                DispatchQueue.main.async {
                    self?.lessons = model.lessons
                }
                print("lessons api success  \(model.lessons.count)")
                self?.lessonsClosure?(model.lessons)
            }
        }
    }
}
