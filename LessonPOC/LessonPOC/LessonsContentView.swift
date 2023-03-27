//
//  ContentView.swift
//  LessonPOC
//
//  Created by Abhishek Suryawanshi on 19/03/23.
//

import SwiftUI

struct LessonsContentView: View {
    
    @ObservedObject var lessonsViewModel: LessonsViewModel = LessonsViewModel()
    @State private var isPresentingMyViewController = false
    
    var body: some View {
        NavigationView {
            List(lessonsViewModel.lessons) { lesson in
                NavigationLink(destination: LessonsWraper(lesson: lesson)) {
                    VStack(alignment: .leading) {
                        LessonItemView(lesson: lesson)
                    }
                }
            }
            .navigationBarTitle(Text("Lessons"))
        }
        .onAppear {
            lessonsViewModel.fetchLessons()
        }
    }
}


struct LessonListScreen_Previews: PreviewProvider {
    static var previews: some View {
        LessonsContentView()
    }
}

