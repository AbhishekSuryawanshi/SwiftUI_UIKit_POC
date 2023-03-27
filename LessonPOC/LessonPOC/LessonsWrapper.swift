//
//  TestWrapper.swift
//  LessonPOC
//
//  Created by Abhishek Suryawanshi on 19/03/23.
//

import Foundation

import SwiftUI

struct LessonsWraper: UIViewControllerRepresentable {

    typealias UIViewControllerType = LessonsDetailsViewController
    
    let lesson: Lesson
    
    class Coordinator {
        var parentObserver: NSKeyValueObservation?
    }

    func makeUIViewController(context: Self.Context) -> LessonsDetailsViewController {
        let viewController = LessonsDetailsViewController(lesson: lesson)
        context.coordinator.parentObserver = viewController.observe(\.parent, changeHandler: { vc, _ in
            vc.parent?.navigationItem.rightBarButtonItems = vc.navigationItem.rightBarButtonItems
        })
        return viewController
    }

    func updateUIViewController(_ uiViewController: LessonsDetailsViewController, context: Self.Context) {}

    func makeCoordinator() -> Self.Coordinator { Coordinator() }
}
