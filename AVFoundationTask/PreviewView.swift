//
//  PreviewView.swift
//  AVFoundationTask
//
//  Created by Indra Sumawi on 10/07/19.
//  Copyright © 2019 Indra Sumawi. All rights reserved.
//

import UIKit
import AVFoundation
class PreviewView: UIView {
    // create view forplacing thecameralive preview
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override  class  var layerClass :  AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer  as! AVCaptureVideoPreviewLayer
    }
}
