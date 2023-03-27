//
//  DownloadTaskManger.swift
//  LessonPOC
//
//  Created by Abhishek Suryawanshi on 25/03/23.
//

import Foundation

let urlString = "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4"


class DownloadTaskManager: NSObject, URLSessionDownloadDelegate {
    
    private var downloadTask: URLSessionDownloadTask?
    private var downloadTaskProgressObservation: NSKeyValueObservation?
    
    var progressPercentage: ((Double) -> ())?
    var downloadSuccess: ((Bool) -> ())?
    
    private var fileName: String = "video.mp4"
    
    func startDownloadTask(videoUrl: String) {
        
        guard let url = URL(string: videoUrl) else {
            return
        }
        
        fileName = url.lastPathComponent // "accudvh5jy.mp4"
        print("FileName \(fileName)")
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        downloadTask = session.downloadTask(with: url)
        downloadTask?.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destinationUrl = documentsPath.appendingPathComponent(fileName)
            // Check if a file with the same name already exists in the destination directory and remove it if it does
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                try FileManager.default.removeItem(at: destinationUrl)
            }
            try FileManager.default.moveItem(at: location, to: destinationUrl)
            print("Video saved successfully at: \(destinationUrl.absoluteString)")
            
        } catch {
            print("Error saving video: \(error.localizedDescription)")
        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        progressPercentage?(progress)
        print("Download progress: \(progress)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("Download failed with error: \(error.localizedDescription)")
            downloadSuccess?(false)
        } else {
            print("Download completed successfully.")
            downloadSuccess?(true)
        }
    }
    
    func cancelDownloadTask() {
        downloadTask?.cancel()
    }
}


