//
//  VideoCell.swift
//  AVPlayerProtocol
//
//  Created by James Rochabrun on 2/11/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class VideoCell: UITableViewCell {
    
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
