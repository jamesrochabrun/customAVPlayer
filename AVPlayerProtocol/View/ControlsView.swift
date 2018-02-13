//
//  ControlsView.swift
//  AVPlayerProtocol
//
//  Created by James Rochabrun on 2/12/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class ControlsView: BaseView {
    
    // MARK: UI ELements
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var skipButton: UIButton = {
        let b = UIButton(type: .system)
        b.addTarget(self, action: #selector(skip), for: .touchUpInside)
        b.setTitle("Rediscover Moments", for: .normal)
        //  b.titleLabel?.font = UIFont.init(name: "OpenSans-Semibold", size: 16) ?? UIFont()
        b.setTitleColor(.white, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .red
        return b
    }()
    
    let replayButton: UIButton = {
        let b = UIButton(type: .system)
        b.addTarget(self, action: #selector(replay), for: .touchUpInside)
        b.backgroundColor = .red
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    // MARK: Properties
    weak var delegate: ControlsViewDelegate?
    
    // MARK: Init
    override func setUpViews() {
        addSubview(skipButton)
        addSubview(replayButton)
        addSubview(activityIndicatorView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// corner radius
        replayButton.layer.cornerRadius = replayButton.frame.width / 2
        skipButton.layer.cornerRadius = 23
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            skipButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            skipButton.heightAnchor.constraint(equalToConstant: 44),
            skipButton.widthAnchor.constraint(equalToConstant: 200),
            skipButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            
            replayButton.heightAnchor.constraint(equalToConstant: 44),
            replayButton.widthAnchor.constraint(equalToConstant: 44),
            replayButton.leftAnchor.constraint(equalTo: skipButton.rightAnchor, constant: 10),
            replayButton.bottomAnchor.constraint(equalTo: skipButton.bottomAnchor)
            ])
    }
    
    // MARK: -  Buttons unhide buttons now
    func hideButtons(_ hide: Bool) {
        replayButton.alpha = hide ? 0 : 1
        skipButton.alpha = hide ? 0 : 1
    }
    
    // MARK: - Actions
    @objc func skip() {
        delegate?.skipButtonTapped()
    }
    
    @objc func replay() {
        delegate?.replayButtonTapped()
    }
}
