//
//  LessonsDetailsViewController.swift
//  LessonPOC
//
//  Created by Abhishek Suryawanshi on 24/03/23.
//

import UIKit
import AVKit
import Foundation

class LessonsDetailsViewController: UIViewController{
    
    private let lesson: Lesson
    
    private let dateLabel = UILabel()
    private var avPlayer = AVPlayer()
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private var videoView: UIView!
    private var videoTitleLabel: UILabel!
    private var playPauseButton: UIButton!
    private var downloadButton: UIButton!
    private var videoDescriptionLabel: UILabel!
    private var downloadBarButtonItem: UIBarButtonItem!
    private var progressBarButtonItem: UIBarButtonItem!
    private var downloadTextBarButtonItem: UIBarButtonItem!
    private var cancelTextBarButtonItem: UIBarButtonItem!
    
    var serviceManager: LessonsDownloadProtocol
    
    let reachability = NetworkManager()
    
    init(lesson: Lesson,serviceManager: LessonsDownloadProtocol = LessonsDownloadManager()) {
        
        self.lesson = lesson
        self.serviceManager = serviceManager
        
        super.init(nibName: nil, bundle: nil)
        
        downloadBarButtonItem = makeDownloadButton()
        
        let progressView = makeProgreeView()
        progressBarButtonItem = UIBarButtonItem(customView: progressView)
        downloadTextBarButtonItem = makeDownloadButtonText()
        cancelTextBarButtonItem = makeCancelButtonText()
        
        navigationItem.rightBarButtonItems = [downloadTextBarButtonItem, cancelTextBarButtonItem, downloadBarButtonItem, progressBarButtonItem]
        
        progressBarButtonItem.isHidden = true
        downloadBarButtonItem.isHidden = false
        downloadTextBarButtonItem.isHidden = false
        cancelTextBarButtonItem.isHidden = true
        
        self.serviceManager.progressPercentage = { percenatge in
            DispatchQueue.main.async {
                print("percentage in viewcontroller \(percenatge)")
                let floatValue = Float(percenatge)
                progressView.setProgress(to: floatValue)
            }
        }
        self.serviceManager.downloadSuccess = { value in
            DispatchQueue.main.async {
                print("download success or fail =  \(value)")
                if value {
                    self.progressBarButtonItem.isHidden = true
                    self.downloadBarButtonItem.isHidden = false
                    self.downloadTextBarButtonItem.isHidden = false
                    self.cancelTextBarButtonItem.isHidden = true
                }
            }
        }
    }
    
    
    
    private func makeDownloadButton() -> UIBarButtonItem {
        let image = UIImage(systemName: "icloud.and.arrow.down")
        let imageButton = UIButton(type: .custom)
        imageButton.setImage(image, for: .normal)
        imageButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return UIBarButtonItem(customView: imageButton)
    }
    
    private func makeProgreeView() -> CircularProgressView {
        let progressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), lineWidth: nil, rounded: false)
        progressView.progressColor = .systemBlue
        progressView.trackColor = .lightGray
        progressView.center = view.center
        progressView.progress = 0.6
        return progressView
    }
    
    private func makeDownloadButtonText() -> UIBarButtonItem {
        return UIBarButtonItem.init(title: "Download", style: .done, target: self, action: #selector(downloadButtonTapped))
    }
    
    private func makeCancelButtonText() -> UIBarButtonItem {
        return  UIBarButtonItem.init(title: "Cancel", style: .done, target: self, action: #selector(cancelDownload))
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        containerView.backgroundColor = .white
        
        videoView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/4))
        containerView.addSubview(videoView)
        
        if let videoUrl = videoUrlPath {
            player = AVPlayer(url: videoUrl)
        }
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer)
        
        playPauseButton = UIButton(type: .system)
        if let pauseImage = UIImage(systemName: "pause.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal) {
            playPauseButton.setImage(pauseImage, for: .normal)
        }
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        videoView.addSubview(playPauseButton)
        NSLayoutConstraint.activate([
            playPauseButton.centerXAnchor.constraint(equalTo: videoView.centerXAnchor),
            playPauseButton.centerYAnchor.constraint(equalTo: videoView.centerYAnchor),
        ])
        
        videoTitleLabel = UILabel(frame: CGRect(x: 10, y: videoView.frame.maxY + 20, width: view.frame.width, height: 0))
        videoTitleLabel.numberOfLines = 0
        videoTitleLabel.textAlignment = .left
        videoTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        videoTitleLabel.text = lesson.name
        videoTitleLabel.sizeToFit()
        videoTitleLabel.text = lesson.name
        containerView.addSubview(videoTitleLabel)
        
        videoDescriptionLabel = UILabel(frame: CGRect(x: 10, y: videoTitleLabel.frame.maxY + 10, width: view.frame.width - 20, height: 0))
        videoDescriptionLabel.numberOfLines = 0
        videoDescriptionLabel.textAlignment = .left
        videoDescriptionLabel.text = lesson.description
        videoDescriptionLabel.sizeToFit()
        videoDescriptionLabel.text = lesson.description
        containerView.addSubview(videoDescriptionLabel)
        
        view.addSubview(containerView)
        player.play()
    }
    
    @objc func playPauseButtonTapped() {
        switch player.timeControlStatus {
        case .paused:
            player.play()
            setButtonImage(named: "pause.fill")
        case .playing:
            player.pause()
            setButtonImage(named: "play.fill")
        case .waitingToPlayAtSpecifiedRate:
            break
        @unknown default:
            break
        }
    }
    
    private func setButtonImage(named imageName: String) {
        if let image = UIImage(systemName: imageName)?.withTintColor(.white, renderingMode: .alwaysOriginal) {
            playPauseButton.setImage(image, for: .normal)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.main.async {
            self.player.pause()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let isLandscape = UIDevice.current.orientation.isLandscape
        let height = isLandscape ? size.height : size.width * 9/16
        
        playerLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: height)
    }
    
    @objc func downloadButtonTapped() {
        progressBarButtonItem.isHidden = false
        downloadBarButtonItem.isHidden = true
        downloadTextBarButtonItem.isHidden = true
        cancelTextBarButtonItem.isHidden = false
        serviceManager.downloadVideoManager(videoUrl: lesson.video_url)
    }
    
    @objc func cancelDownload() {
        progressBarButtonItem.isHidden = true
        downloadBarButtonItem.isHidden = false
        downloadTextBarButtonItem.isHidden = false
        cancelTextBarButtonItem.isHidden = true
        serviceManager.cancelVideoDownload()
    }
}

fileprivate extension LessonsDetailsViewController {
    var videoUrlPath: URL? {
        guard self.reachability.isNetworkAvailable else {
            print("Network is not available")
            if let localPath = findLocalPath(for: URL(string: lesson.video_url)!) {
                return URL(filePath: localPath)
            }
            return URL(string: "video.mp4")
        }
        print("network avilable")
        return URL(string: lesson.video_url)
    }
    
    func findLocalPath(for lessonUrl: URL) -> String? {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationUrl = documentsPath.appendingPathComponent(lessonUrl.lastPathComponent)
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            return destinationUrl.path
        }
        return nil
    }
}
