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
        let path = Bundle.main.path(forResource: "onboarding", ofType:"mp4")
        let player = AVPlayer(url: URL(fileURLWithPath: path!))
        return player
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
        setUpControlsLayout()
    }
    
    // MARK: -  Setup Views Layout
    private func setUpPlayerView() {
       // self.playerLayer = AVPlayerLayer(player: player)
        guard let playerLayer = self.playerLayer else { return }
        playerLayer.frame = frame
        layer.addSublayer(playerLayer)
        player.play()
    }
    
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
        UIView.animate(withDuration: 0.3) {
            self.controlsContainerView.hideButtons(false)
            self.controlsContainerView.alpha = 1.0
        }
    }
}


extension VideoPlayerView: ControlsViewDelegate {
    
    func skipButtonTapped() {
        delegate?.skip()
    }
    
    func replayButtonTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.controlsContainerView.alpha = 0
        }) { (_) in
            self.player.seek(to: kCMTimeZero)
            self.player.play()
        }
    }
}


protocol ControlsViewDelegate: class {
    func skipButtonTapped()
    func replayButtonTapped()
}




















