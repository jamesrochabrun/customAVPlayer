//
//  VideoplayerView.swift
//  AVPlayerProtocol
//
//  Created by James Rochabrun on 2/11/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.

import UIKit
import AVFoundation

protocol VideoPlayerViewDelegate: class {
    func skip()
}

class VideoPlayerView: BaseView {
    
    static let loadedTimes: String = "currentItem.loadedTimeRanges"
    // Just in case is needed
    //  let w = frame.height * 9 / 16
    
    // MARK: UI Elements
    let player: AVPlayer = {
        let path = Bundle.main.path(forResource: "vid", ofType:"mp4")
        let player = AVPlayer(url: URL(fileURLWithPath: path!))
        return player
    }()
    
    let videoImagePlaceHolderView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.alpha = 0
        iv.image = #imageLiteral(resourceName: "mfyVideo")
        return iv
    }()
    
    var playerLayer: AVPlayerLayer?
    
    lazy var controlsContainerView: ControlsView = {
        let cView = ControlsView()
        cView.delegate = self
        cView.hideButtons(true)
        return cView
    }()
    
    // MARK: - Properties
    weak var delegate: VideoPlayerViewDelegate?
    
    // MARK: -  override Init
    override func setUpViews() {
        self.playerLayer = AVPlayerLayer(player: player)
        addSubview(videoImagePlaceHolderView)
        addSubview(controlsContainerView)
        registerNotificationsForVideoStatus()
    }
    
    private func registerNotificationsForVideoStatus() {
        player.addObserver(self, forKeyPath: VideoPlayerView.loadedTimes, options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinished),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        player.removeObserver(self, forKeyPath: VideoPlayerView.loadedTimes)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        /// Setting the frames here after the frames are defined
        setUpPlayerView()
        setUpPlaceHolderLayout()
        setUpControlsLayout()
    }
    
    // MARK: -  Setup Views Layout "layers"
    /// Video Layer
    private func setUpPlayerView() {
       // self.playerLayer = AVPlayerLayer(player: player)
        guard let playerLayer = self.playerLayer else { return }
        playerLayer.frame = frame
        layer.addSublayer(playerLayer)
        player.play()
    }
    
    /// PlaceHolder Layer
    private func setUpPlaceHolderLayout() {
        videoImagePlaceHolderView.frame = frame
        bringSubview(toFront: videoImagePlaceHolderView)
    }
    
    /// Controls Layer
    private func setUpControlsLayout() {
        controlsContainerView.frame = frame
        bringSubview(toFront: controlsContainerView)
    }
    
    // MARK: - Set up KVO for starting point of video
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        /// this is when the player is ready and rendering frames
        if keyPath == VideoPlayerView.loadedTimes {
            controlsContainerView.activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
        }
    }
    
    // MARK: - Set up notification for ending point of video
    @objc private func playerDidFinished() {
        UIView.animate(withDuration: 0.4) {
            self.controlsContainerView.hideButtons(false)
            self.controlsContainerView.alpha = 1.0
            self.videoImagePlaceHolderView.alpha = 1.0
        }
    }
}

// MARK: - ControlsVIew actions Skip && Replay
extension VideoPlayerView: ControlsViewDelegate {
    
    func skipButtonTapped() {
        delegate?.skip()
    }
    
    func replayButtonTapped() {
        self.player.seek(to: kCMTimeZero)
        UIView.animate(withDuration: 0.5, animations: {
            self.controlsContainerView.alpha = 0
            self.videoImagePlaceHolderView.alpha = 0
        }) { (_) in
                self.player.play()
        }
    }
}





















