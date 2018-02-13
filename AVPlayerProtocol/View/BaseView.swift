//
//  BaseView.swift
//  AVPlayerProtocol
//
//  Created by James Rochabrun on 2/11/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

//This Base class handles xib setup and view init
class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    
    //MARK: To be override for subclasses
    func setUpViews() {
    }
}
