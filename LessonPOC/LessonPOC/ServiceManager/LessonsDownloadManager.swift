//
//  LessonsDownloadManager.swift
//  LessonPOC
//
//  Created by Abhishek Suryawanshi on 25/03/23.
//

import Foundation

protocol LessonsDownloadProtocol {
    func downloadVideoManager(videoUrl: String)
    func cancelVideoDownload()
    var progressPercentage: ((Double) -> ())? { get set }
    var downloadSuccess: ((Bool) -> ())? { get set }
}

class LessonsDownloadManager: LessonsDownloadProtocol {
    var downloadSuccess: ((Bool) -> ())?
    var progressPercentage: ((Double) -> ())?
    let downloadTaskManager: DownloadTaskManager
    
    init(client: DownloadTaskManager = DownloadTaskManager()) {
        self.downloadTaskManager = client
        downloadTaskManager.downloadSuccess = { value in
            self.downloadSuccess?(value)
        }
    }
    
    func downloadVideoManager(videoUrl: String) {
        downloadTaskManager.progressPercentage = { value in
            self.progressPercentage?(value)
        }
        downloadTaskManager.startDownloadTask(videoUrl: urlString)
    }
    
    func cancelVideoDownload() {
        downloadTaskManager.cancelDownloadTask()
    }
}
