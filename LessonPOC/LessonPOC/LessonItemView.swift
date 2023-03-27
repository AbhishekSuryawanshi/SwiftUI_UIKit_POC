//
//  LessonItemView.swift
//  LessonPOC
//
//  Created by Abhishek Suryawanshi on 19/03/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct LessonItemView: View {
    
    let lesson: Lesson
    
    var lessosnUrl: URL? {
        return URL(string: lesson.thumbnail)
    }
    
    var body: some View {
        
        HStack(){
            if let url = lessosnUrl {
                WebImage(url: url)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100.0, height: 100.0)
            } else {
                Image(systemName: "book.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100.0, height: 100.0)
            }
            Text(lesson.name)
        }
    }
}

struct LessonItemView_Previews: PreviewProvider {
    static var previews: some View {
        LessonItemView(
            lesson: Lesson(id: 1, name: "Testname",
                           description: "Testname",
                           thumbnail: "",
                           video_url: "")
        )
    }
}
